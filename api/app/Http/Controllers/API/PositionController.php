<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Position;
use Illuminate\Http\Request;

class PositionController extends Controller
{
    public function index()
    {
        return response()->json(Position::all());
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|unique:positions,name',
            'rate_reguler' => 'required|numeric',
            'rate_overtime' => 'required|numeric',
        ]);

        $position = Position::create($validated);
        return response()->json($position, 201);
    }

    public function update(Request $request, Position $position)
    {
        $validated = $request->validate([
            'name' => 'sometimes|required|string|unique:positions,name,' . $position->id,
            'rate_reguler' => 'sometimes|required|numeric',
            'rate_overtime' => 'sometimes|required|numeric',
        ]);

        $position->update($validated);
        return response()->json($position);
    }

    public function destroy(Position $position)
    {
        $position->delete();
        return response()->json(null, 204);
    }
}