<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreTaskRequest;
use App\Http\Requests\UpdateTaskRequest;
use App\Models\Task;
use Illuminate\Http\JsonResponse;

class TaskController extends Controller
{
    /**
     * GET /api/tasks
     * Return all tasks, newest first.
     */
    public function index(): JsonResponse
    {
        $tasks = Task::latest()->get();
        return response()->json($tasks, 200);
    }

    /**
     * GET /api/tasks/{task}
     * Return a single task. Laravel route model binding handles 404 automatically.
     */
    public function show(Task $task): JsonResponse
    {
        return response()->json($task, 200);
    }

    /**
     * POST /api/tasks
     * Create a new task. Validation handled by StoreTaskRequest (returns 422 on failure).
     */
    public function store(StoreTaskRequest $request): JsonResponse
    {
        $task = Task::create($request->validated());
        // fresh() re-fetches from DB to ensure defaults (e.g., status='pending') are present
        return response()->json($task->fresh(), 201);
    }

    /**
     * PUT/PATCH /api/tasks/{task}
     * Update an existing task. Supports partial updates via 'sometimes' rule.
     */
    public function update(UpdateTaskRequest $request, Task $task): JsonResponse
    {
        $task->update($request->validated());
        // fresh() re-fetches from DB to ensure casts/mutators are applied correctly
        return response()->json($task->fresh(), 200);
    }

    /**
     * DELETE /api/tasks/{task}
     * Delete a task. Returns 200 with a message body (not 204) for easy Flutter handling.
     */
    public function destroy(Task $task): JsonResponse
    {
        $task->delete();
        return response()->json(['message' => 'Task deleted successfully.'], 200);
    }
}
