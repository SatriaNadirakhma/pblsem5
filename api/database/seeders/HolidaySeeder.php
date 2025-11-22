<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class HolidaySeeder extends Seeder
{
    public function run(): void
    {
        $holidays = [
            ['date' => '2025-01-01', 'name' => 'Tahun Baru Masehi'],
            ['date' => '2025-01-28', 'name' => 'Imlek 2576'],
            ['date' => '2025-03-31', 'name' => 'Hari Suci Nyepi'],
            ['date' => '2025-04-18', 'name' => 'Wafat Isa Almasih'],
            ['date' => '2025-05-01', 'name' => 'Hari Buruh Internasional'],
            ['date' => '2025-05-29', 'name' => 'Kenaikan Isa Almasih'],
            ['date' => '2025-06-01', 'name' => 'Hari Lahir Pancasila'],
            ['date' => '2025-12-25', 'name' => 'Hari Raya Natal'],
        ];

        DB::table('holidays')->insert($holidays);
    }
}