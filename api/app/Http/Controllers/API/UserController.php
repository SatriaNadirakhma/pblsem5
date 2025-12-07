<?php

namespace App\Http\Controllers\API;

use App\Helpers\ResponseWrapper;
use App\Models\User;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    public function show_user(string $id)
    {
        $user = User::with([
            "employee" => function ($query) {
                $query->select(
                    "id",
                    "user_id",
                    "first_name",
                    "last_name",
                    "gender",
                    "address",
                    "position_id",
                    "department_id",
                );
            },
            "employee.department" => function ($query) {
                $query->select("id", "name");
            },
            "employee.position" => function ($query) {
                $query->select("id", "name");
            },
        ])->find($id);

        if (!$user) {
            return ResponseWrapper::make(
                "User not found",
                404,
                true,
                null,
                null,
            );
        }
        return ResponseWrapper::make("User found", 200, true, $user, null);
    }

    public function show_users()
    {
        $data = User::with([
            "employee" => function ($query) {
                $query->select(
                    "id",
                    "user_id",
                    "first_name",
                    "last_name",
                    "gender",
                    "address",
                    "position_id",
                    "department_id",
                );
            },
            "employee.department" => function ($query) {
                $query->select("id", "name");
            },
            "employee.position" => function ($query) {
                $query->select("id", "name");
            },
        ])->get();

        return ResponseWrapper::make("Users found", 200, true, $data, null);
    }

    /**
     * Update user data (for admin)
     *
     * @param Request $request
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function update_user(Request $request, $id)
    {
        try {
            $user = User::find($id);

            if (!$user) {
                return ResponseWrapper::make(
                    "User tidak ditemukan",
                    404,
                    false,
                    null,
                    null
                );
            }

            // Validation
            $validator = Validator::make($request->all(), [
                'email' => 'sometimes|email|unique:users,email,' . $id,
                'password' => 'sometimes|min:6',
                'is_admin' => 'sometimes|boolean',
            ]);

            if ($validator->fails()) {
                return ResponseWrapper::make(
                    "Validasi gagal",
                    422,
                    false,
                    null,
                    $validator->errors()
                );
            }

            $updateData = $request->only(['email', 'is_admin']);

            // Hash password if provided
            if ($request->has('password')) {
                $updateData['password'] = bcrypt($request->password);
            }

            $user->update($updateData);

            // Reload user with employee relation
            $user->load([
                'employee' => function ($query) {
                    $query->select(
                        'id',
                        'user_id',
                        'first_name',
                        'last_name',
                        'gender',
                        'address',
                        'position_id',
                        'department_id',
                    );
                },
                'employee.department' => function ($query) {
                    $query->select('id', 'name');
                },
                'employee.position' => function ($query) {
                    $query->select('id', 'name');
                },
            ]);

            return ResponseWrapper::make(
                "Data user berhasil diperbarui",
                200,
                true,
                $user,
                null
            );

        } catch (\Exception $e) {
            return ResponseWrapper::make(
                "Gagal memperbarui user: " . $e->getMessage(),
                500,
                false,
                null,
                $e->getMessage()
            );
        }
    }
}
