<?php

use App\Http\Controllers\Api\TaskController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
| All routes here are prefixed with /api automatically by Laravel.
| Route::apiResource registers the 5 standard RESTful routes:
|   GET    /api/tasks          → index
|   POST   /api/tasks          → store
|   GET    /api/tasks/{task}   → show
|   PUT    /api/tasks/{task}   → update
|   PATCH  /api/tasks/{task}   → update
|   DELETE /api/tasks/{task}   → destroy
*/

Route::apiResource('tasks', TaskController::class);
