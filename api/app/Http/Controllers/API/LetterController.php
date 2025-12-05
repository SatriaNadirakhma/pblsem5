<?php

namespace App\Http\Controllers\API;

use App\Helpers\ResponseWrapper;
use App\Models\Letter;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class LetterController extends Controller
{

    public function index(Request $request)
    {
        try {
            $query = Letter::with(['employee', 'format']);

            if ($request->status !== null) {
                $query->where('status', $request->status);
            }

            if ($request->employee_id) {
                $query->where('employee_id', $request->employee_id);
            }

            $letters = $query->orderBy('id', 'desc')->get();

            return ResponseWrapper::make(
                "Data surat berhasil dimuat",
                200,
                true,
                $letters,
                null
            );

        } catch (\Exception $e) {
            return ResponseWrapper::make(
                "Gagal memuat data surat",
                500,
                false,
                null,
                $e->getMessage()
            );
        }
    }

    public function show($id)
    {
        try {
            $letter = Letter::with(['employee', 'format'])->findOrFail($id);

            return ResponseWrapper::make(
                "Detail surat berhasil dimuat",
                200,
                true,
                $letter,
                null
            );

        } catch (\Exception $e) {
            return ResponseWrapper::make(
                "Surat tidak ditemukan",
                404,
                false,
                null,
                $e->getMessage()
            );
        }
    }

    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'letter_format_id'       => 'required|exists:letter_formats,id',
                'employee_id'            => 'required|exists:employees,id',
                'title'                  => 'required|string|max:255',
                'effective_start_date'   => 'required|date',
                'effective_end_date'     => 'required|date|after_or_equal:effective_start_date',
                'notes'                  => 'nullable|string',
            ]);

            $validated['status'] = 0; // pending
            $validated['request_date'] = Carbon::now()->toDateString();

            $letter = Letter::create($validated);

            return ResponseWrapper::make(
                "Pengajuan surat berhasil dibuat",
                201,
                true,
                $letter,
                null
            );

        } catch (\Exception $e) {
            return ResponseWrapper::make(
                "Gagal membuat pengajuan surat",
                500,
                false,
                null,
                $e->getMessage()
            );
        }
    }

    public function updateStatus(Request $request, $id)
    {
        try {
            $validated = $request->validate([
                'status' => 'required|in:0,1,2'
            ]);

            $letter = Letter::findOrFail($id);

            $letter->status = $validated['status'];
            $letter->approved_by = $request->approved_by ?? null;
            $letter->approved_at = Carbon::now();
            $letter->save();

            return ResponseWrapper::make(
                "Status surat berhasil diperbarui",
                200,
                true,
                $letter,
                null
            );

        } catch (\Exception $e) {
            return ResponseWrapper::make(
                "Gagal memperbarui status surat",
                500,
                false,
                null,
                $e->getMessage()
            );
        }
    }

    public function destroy($id)
    {
        try {
            $letter = Letter::findOrFail($id);
            $letter->delete();

            return ResponseWrapper::make(
                "Surat berhasil dihapus",
                200,
                true,
                null,
                null
            );

        } catch (\Exception $e) {
            return ResponseWrapper::make(
                "Gagal menghapus surat",
                500,
                false,
                null,
                $e->getMessage()
            );
        }
    }
}
