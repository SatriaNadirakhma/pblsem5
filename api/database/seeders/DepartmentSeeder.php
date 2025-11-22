<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class DepartmentSeeder extends Seeder
{
    public function run(): void
    {
        $departments = [
            ['name' => 'IT Development',     'latitude' => -7.983908, 'longitude' => 112.630798, 'radius_meters' => 200],
            ['name' => 'Human Resource',     'latitude' => -7.975500, 'longitude' => 112.625900, 'radius_meters' => 180],
            ['name' => 'Finance & Accounting','latitude' => -7.977000, 'longitude' => 112.633000, 'radius_meters' => 150],
            ['name' => 'Marketing',          'latitude' => -7.980000, 'longitude' => 112.626000, 'radius_meters' => 220],
            ['name' => 'Operational',        'latitude' => -7.982000, 'longitude' => 112.632000, 'radius_meters' => 250],
            ['name' => 'General Affair',     'latitude' => -7.984000, 'longitude' => 112.629000, 'radius_meters' => 200],
        ];

        DB::table('departments')->insert($departments);
    }
}