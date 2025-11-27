<?php

use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\EmployeeController; 
use App\Http\Controllers\Api\PositionController;
use App\Http\Controllers\Api\DepartmentController;
Route::get("/user/{id}", [UserController::class, "show_user"]);

Route::post("/login", [AuthController::class, "login"]);
Route::post("/register", [AuthController::class, "register"])->middleware(
    "auth:sanctum",
);
Route::apiResource('employees', EmployeeController::class)
     ->only(['index', 'show', 'update']); 
Route::apiResource('positions', PositionController::class);
Route::apiResource('departments', DepartmentController::class);