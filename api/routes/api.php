<?php

use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\DepartementController;
use App\Http\Controllers\API\PositionController;
use Illuminate\Support\Facades\Route;

Route::get("/user/{id}", [UserController::class, "show_user"])->middleware(
    "auth:sanctum",
);
Route::get("/users", [UserController::class, "show_users"])->middleware(
    "auth:sanctum",
);
Route::get("/departements", [DepartementController::class,"show_departements"])->middleware("auth:sanctum");
Route::get("/positions", [PositionController::class, "show_positions"]);

Route::post("/login", [AuthController::class, "login"]);
Route::post("/register", [AuthController::class, "register"])->middleware(
    "auth:sanctum",
);
