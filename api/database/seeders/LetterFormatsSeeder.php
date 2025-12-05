<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class LetterFormatsSeeder extends Seeder
{
    public function run()
    {
        $now = Carbon::now();

        $content = <<<EOT
SURAT IZIN {{NAMA SURAT}}

Perihal: Izin {{NAMA SURAT}}
Lampiran: -

Kepada Yth. HRD
Di 
Tempat.

Dengan hormat,

Saya yang bertanda tangan di bawah ini:

Nama        : {{first_name}} {{last_name}}
Jabatan     : {{position}}
Departemen  : {{department_name}}

Bermaksud untuk mengajukan surat permohonan cuti tahunan pada tanggal [dd/mm/yyyy] hingga [dd/mm/yyyy].

Demikian surat izin ini saya ajukan. Atas pengertiannya, saya ucapkan terima kasih.

Hormat saya


{{first name}} {{last name}}
EOT;

        DB::table('letter_formats')->updateOrInsert(
            ['name' => 'Surat Izin Default'],   // pastikan selalu ada
            [
                'content' => $content,
                'updated_at' => $now,
                'created_at' => $now
            ]
        );
    }
}
