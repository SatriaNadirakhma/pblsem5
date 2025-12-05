<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Position extends Model
{
    protected $fillable = ["name", "rate_reguler", "rate_overtime"];

    public function employees(): HasMany
    {
        return $this->hasMany(Employee::class);
    }

    public function user()
    {
        return $this->hasMany(User::class);
    }
}
