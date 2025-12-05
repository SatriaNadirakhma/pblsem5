<?php

namespace App\Http\Controllers\API;

use App\Helpers\ResponseWrapper;
use App\Http\Controllers\Controller;
use App\Models\Position;
use Illuminate\Http\Request;

class PositionController extends Controller
{
    public function show_positions()
    {
        $positions = Position::all(["id", "name"]);
        return ResponseWrapper::make(
            "Positions found",
            200,
            true,
            $positions,
            null,
        );
    }
}
