<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('employees', function (Blueprint $table) {
            $table->foreignId('position_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('department_id')->nullable()->constrained()->nullOnDelete();
            $table->enum('employment_status', ['aktif', 'cuti', 'resign', 'phk'])->default('aktif');

            // Hapus kolom yang ga dipakai lagi
            if (Schema::hasColumn('employees', 'ck_settings_id')) {
                $table->dropColumn('ck_settings_id');
            }
        });
    }

    public function down(): void
    {
        Schema::table('employees', function (Blueprint $table) {
            $table->dropForeign(['position_id']);
            $table->dropForeign(['department_id']);
            $table->dropColumn(['position_id', 'department_id', 'employment_status']);
        });
    }
};