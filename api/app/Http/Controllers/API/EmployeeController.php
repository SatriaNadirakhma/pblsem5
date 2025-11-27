<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Employee;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Throwable;

class EmployeeController extends Controller
{
    public function index(): JsonResponse
    {
        $employees = Employee::with(['user', 'position', 'department'])->get();

        return response()->json([
            'success' => true,
            'message' => 'Daftar karyawan berhasil diambil.',
            'data'    => $employees,
        ], 200);
    }

    /**
     * Update karyawan – baik data pribadi (karyawan) maupun status/posisi/departemen (admin)
     */
    public function update(Request $request, Employee $employee): JsonResponse
    {
        // Laravel tidak otomatis membaca _method pada API JSON,
        // jadi kita paksa spoofing manual kalau ada field _method
        if ($request->has('_method') && strtoupper($request->_method) === 'PATCH') {
            $request->merge(['_method' => 'PATCH']);
        }

        // Validasi hanya field yang dikirim (sometimes)
        $validator = Validator::make($request->all(), $this->rules($employee));

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal.',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $data = $validator->validated();

        // Hapus _method dari data yang akan disimpan
        unset($data['_method']);

        try {
            DB::beginTransaction();

            $employee->update($data);

            DB::commit();

            // Reload relasi biar data terbaru dikembalikan ke Flutter
            $employee->load(['user', 'position', 'department']);

            return response()->json([
                'success' => true,
                'message' => 'Data karyawan berhasil diperbarui.',
                'data'    => $employee,
            ], 200);

        } catch (Throwable $e) {
            DB::rollBack();

            Log::error('Employee update failed', [
                'employee_id' => $employee->id,
                'error'       => $e->getMessage(),
                'trace'       => $e->getTraceAsString(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui data karyawan.',
                'error'   => $e->getMessage(), // optional, hapus kalau tidak mau expose
            ], 500);
        }
    }

    /**
     * Aturan validasi – semua field bersifat "sometimes" karena
     * karyawan hanya edit data pribadi, admin edit status/posisi/departemen
     */
    private function rules(Employee $employee): array
    {
        return [
            '_method'          => 'sometimes|in:PATCH,PUT', // untuk spoofing

            'first_name'       => 'sometimes|required|string|max:100',
            'last_name'        => 'sometimes|required|string|max:100',
            'gender'           => ['sometimes', 'required', 'in:L,P'],
            'address'          => 'sometimes|required|string',

            // Admin only
            'employment_status'=> ['sometimes', 'required', 'in:aktif,cuti,resign,phk'],
            'position_id'      => 'sometimes|nullable|integer|exists:positions,id',
            'department_id'    => 'sometimes|nullable|integer|exists:departments,id',
        ];
    }
}