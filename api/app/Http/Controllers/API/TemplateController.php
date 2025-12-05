<?php

namespace App\Http\Controllers\API;

use App\Helpers\ResponseWrapper;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class TemplateController extends Controller
{
    /**
     * List semua template
     */
    public function index()
    {
        try {
            $templates = DB::table('letter_formats')
                ->select('id', 'name', 'content', 'created_at')
                ->orderBy('created_at', 'desc')
                ->get();

            return ResponseWrapper::make(
                "List template berhasil dimuat",
                200,
                true,
                $templates,
                null
            );
        } catch (\Exception $e) {
            return ResponseWrapper::make(
                "Gagal memuat template",
                500,
                false,
                null,
                $e->getMessage()
            );
        }
    }


    /**
     * Membuat template baru
     */
    public function store(Request $request)
    {
        try {
            $request->validate([
                'name'    => 'required|string|max:255',
                'content' => 'nullable|string',
            ]);

            // Ambil template default
            $default = DB::table('letter_formats')
                ->where('id', 1)
                ->first();

            if (!$default) {
                return ResponseWrapper::make(
                    "Template default tidak ditemukan",
                    404,
                    false,
                    null,
                    null
                );
            }

            // Jika content tidak diberikan → pakai content default
            $content = $request->input('content') ?: $default->content;


            $newTemplate = [
                'name'       => $request->name,
                'content'    => $content,
                'created_at' => Carbon::now(),
                'updated_at' => Carbon::now(),
            ];

            DB::table('letter_formats')->insert($newTemplate);

            return ResponseWrapper::make(
                "Template baru berhasil dibuat",
                201,
                true,
                $newTemplate,
                null
            );
        } catch (\Exception $e) {
            return ResponseWrapper::make(
                "Gagal membuat template",
                500,
                false,
                null,
                $e->getMessage()
            );
        }
    }


    /**
     * Detail template
     */
    public function show($id)
    {
        try {
            $template = DB::table('letter_formats')->find($id);

            if (!$template) {
                return ResponseWrapper::make(
                    "Template tidak ditemukan",
                    404,
                    false,
                    null,
                    null
                );
            }

            return ResponseWrapper::make(
                "Detail template berhasil dimuat",
                200,
                true,
                $template,
                null
            );
        } catch (\Exception $e) {
            return ResponseWrapper::make(
                "Gagal memuat detail template",
                500,
                false,
                null,
                $e->getMessage()
            );
        }
    }

    /**
     * Update template tertentu
     */
    public function update(Request $request, $id)
    {
        try {
            $request->validate([
                'name'    => 'nullable|string|max:255',
                'content' => 'nullable|string',
            ]);

            // Ambil template
            $template = DB::table('letter_formats')->find($id);

            if (!$template) {
                return ResponseWrapper::make(
                    "Template tidak ditemukan",
                    404,
                    false,
                    null,
                    null
                );
            }

            // Cegah update untuk template default
            if ($template->name === "Surat Izin Default") {
                return ResponseWrapper::make(
                    "Template default tidak boleh diubah",
                    400,
                    false,
                    null,
                    null
                );
            }

            // Gunakan data lama jika tidak diisi
            $updatedData = [
                'name'       => $request->input('name', $template->name),
                'content'    => $request->input('content', $template->content),
                'updated_at' => Carbon::now(),
            ];

            DB::table('letter_formats')
                ->where('id', $id)
                ->update($updatedData);

            return ResponseWrapper::make(
                "Template berhasil diperbarui",
                200,
                true,
                $updatedData,
                null
            );
        } catch (\Exception $e) {
            return ResponseWrapper::make(
                "Gagal memperbarui template",
                500,
                false,
                null,
                $e->getMessage()
            );
        }
    }



    /**
     * Hapus template tertentu
     */
    public function destroy($id)
    {
        try {
            $template = DB::table('letter_formats')->find($id);

            if (!$template) {
                return ResponseWrapper::make(
                    "Template tidak ditemukan",
                    404,
                    false,
                    null,
                    null
                );
            }

            // Jangan izinkan menghapus template default
            if ($template->name === "Surat Izin Default") {
                return ResponseWrapper::make(
                    "Template default tidak boleh dihapus",
                    400,
                    false,
                    null,
                    null
                );
            }

            DB::table('letter_formats')->where('id', $id)->delete();

            return ResponseWrapper::make(
                "Template berhasil dihapus",
                200,
                true,
                null,
                null
            );
        } catch (\Exception $e) {
            return ResponseWrapper::make(
                "Gagal menghapus template",
                500,
                false,
                null,
                $e->getMessage()
            );
        }
    }
}
