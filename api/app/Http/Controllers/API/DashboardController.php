<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index()
    {
        $totalEmployees = DB::table('employees')->count();

        $totalPending = DB::table('letters')
            ->where('status', 0)
            ->count();

        $totalValidated = DB::table('letters')
            ->whereIn('status', [1, 2])
            ->count();

        $departments = DB::table('letters')
            ->join('employees', 'letters.employee_id', '=', 'employees.id')
            ->join('departments', 'employees.department_id', '=', 'departments.id')
            ->select('departments.name as department_name', DB::raw('count(*) as izin_count'))
            ->whereIn('letters.status', [0, 1, 2])
            ->groupBy('departments.id', 'departments.name')
            ->get();

        return response()->json([
            'total_pending' => $totalPending,
            'total_validated' => $totalValidated,
            'total_employees' => $totalEmployees,
            'departments' => $departments,
        ]);
    }
}