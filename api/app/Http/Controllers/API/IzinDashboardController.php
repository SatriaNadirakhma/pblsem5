<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class IzinDashboardController extends Controller
{
    public function __invoke()
    {
        // Total karyawan yang mengajukan izin (pending = status 0)
        $totalPending = DB::table('letters')
            ->where('status', 0)
            ->distinct('employee_id')
            ->count('employee_id');

        $totalEmployees = DB::table('employees')->count();

        // Statistik per departemen
        $departments = DB::table('departments')
            ->leftJoin('employees', 'employees.department_id', '=', 'departments.id')
            ->leftJoin('letters', function ($join) {
                $join->on('letters.employee_id', '=', 'employees.id')
                     ->where('letters.status', '=', 0); // hanya yang pending
            })
            ->select(
                'departments.id',
                'departments.name',
                DB::raw('COUNT(DISTINCT employees.id) as total_karyawan'),
                DB::raw('COUNT(DISTINCT letters.id) as pending_izin')
            )
            ->groupBy('departments.id', 'departments.name')
            ->get()
            ->map(function ($dept) {
                return [
                    'name' => $dept->name,
                    'count' => "{$dept->pending_izin} / {$dept->total_karyawan}"
                ];
            });

        return response()->json([
            'total_pending'    => $totalPending,
            'total_employees'  => $totalEmployees,
            'departments'      => $departments,
        ]);
    }
}