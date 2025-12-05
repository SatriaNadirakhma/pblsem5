<?php

use App\Http\Controllers\API\IzinDashboardController;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\UserController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\LetterController;
use App\Http\Controllers\API\TemplateController;

Route::get("/user/{id}", [UserController::class, "show_user"]);
Route::get('/test', function () {
    return response()->json(['status' => 'ok']);
});



Route::get('/letters', [LetterController::class, 'index']);
Route::get('/letters/{id}', [LetterController::class, 'show']);
Route::post('/letters', [LetterController::class, 'store']);
Route::put('/letters/{id}/status', [LetterController::class, 'updateStatus']);
Route::delete('/letters/{id}', [LetterController::class, 'destroy']);

Route::get('/izin-dashboard', IzinDashboardController::class);
Route::get('/izin-list', [IzinDashboardController::class, 'izinList']);
Route::post('/izin-update/{id}', [IzinDashboardController::class, 'updateStatus']);
Route::get('/export-approved-letters', [IzinDashboardController::class, 'exportApprovedLetters']);

Route::get('/templates', [TemplateController::class, 'index']);
Route::post('/templates', [TemplateController::class, 'store']);
Route::get('/templates/{id}', [TemplateController::class, 'show']);
Route::put('/templates/{id}', [TemplateController::class, 'update']);
Route::get('/templates/default', [TemplateController::class, 'default']);
Route::delete('/templates/{id}', [TemplateController::class, 'destroy']);




Route::get("/user/{id}", [UserController::class, "show_user"])->middleware(
    "auth:sanctum",
);
Route::get("/users", [UserController::class, "show_users"])->middleware(
    "auth:sanctum",
);

Route::post("/login", [AuthController::class, "login"]);
Route::post("/register", [AuthController::class, "register"])->middleware(
    "auth:sanctum",);
