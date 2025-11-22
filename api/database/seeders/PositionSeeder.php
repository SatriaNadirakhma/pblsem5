<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PositionSeeder extends Seeder
{
    public function run(): void
    {
        $positions = [
            ['name' => 'Staff',             'rate_reguler' => 30000, 'rate_overtime' => 45000],
            ['name' => 'Senior Staff',      'rate_reguler' => 35000, 'rate_overtime' => 52500],
            ['name' => 'Supervisor',        'rate_reguler' => 45000, 'rate_overtime' => 67500],
            ['name' => 'Assistant Manager', 'rate_reguler' => 55000, 'rate_overtime' => 82500],
            ['name' => 'Manager',           'rate_reguler' => 70000, 'rate_overtime' => 105000],
            ['name' => 'General Manager',   'rate_reguler' => 90000, 'rate_overtime' => 135000],
            ['name' => 'Direktur',          'rate_reguler' => 120000,'rate_overtime' => 180000],
        ];

        DB::table('positions')->insert($positions);
    }
}