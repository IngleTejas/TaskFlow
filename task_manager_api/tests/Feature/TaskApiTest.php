<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

/**
 * Feature tests for the Task API endpoints.
 * Uses an in-memory SQLite database (configured in phpunit.xml).
 */
class TaskApiTest extends TestCase
{
    use RefreshDatabase;

    // ── Helper ──────────────────────────────────────────────────────────────

    private function createTask(array $overrides = []): array
    {
        $payload = array_merge([
            'title'       => 'Test Task',
            'description' => 'Test description',
            'due_date'    => '2026-12-31',
        ], $overrides);

        $response = $this->postJson('/api/tasks', $payload);
        return $response->json();
    }

    // ── INDEX ────────────────────────────────────────────────────────────────

    public function test_can_list_all_tasks(): void
    {
        $this->createTask(['title' => 'Task A']);
        $this->createTask(['title' => 'Task B']);

        $this->getJson('/api/tasks')
            ->assertStatus(200)
            ->assertJsonCount(2);
    }

    public function test_empty_list_returns_200(): void
    {
        $this->getJson('/api/tasks')
            ->assertStatus(200)
            ->assertExactJson([]);
    }

    // ── SHOW ─────────────────────────────────────────────────────────────────

    public function test_can_get_single_task(): void
    {
        $task = $this->createTask();

        $this->getJson("/api/tasks/{$task['id']}")
            ->assertStatus(200)
            ->assertJsonFragment(['title' => 'Test Task'])
            ->assertJsonStructure(['id', 'title', 'description', 'status', 'due_date', 'created_at', 'updated_at']);
    }

    public function test_get_nonexistent_task_returns_404(): void
    {
        $this->getJson('/api/tasks/999')
            ->assertStatus(404)
            ->assertJsonStructure(['message']);
    }

    // ── STORE ────────────────────────────────────────────────────────────────

    public function test_can_create_task_with_all_fields(): void
    {
        $this->postJson('/api/tasks', [
            'title'       => 'Buy groceries',
            'description' => 'Milk, eggs, bread',
            'due_date'    => '2026-11-01',
        ])
            ->assertStatus(201)
            ->assertJsonFragment([
                'title'  => 'Buy groceries',
                'status' => 'pending',
            ]);
    }

    public function test_can_create_task_with_title_only(): void
    {
        $this->postJson('/api/tasks', ['title' => 'Minimal task'])
            ->assertStatus(201)
            ->assertJsonFragment(['title' => 'Minimal task'])
            ->assertJsonFragment(['status' => 'pending']);
    }

    public function test_create_task_requires_title(): void
    {
        $this->postJson('/api/tasks', ['description' => 'No title here'])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['title']);
    }

    public function test_create_task_title_max_255(): void
    {
        $this->postJson('/api/tasks', ['title' => str_repeat('a', 256)])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['title']);
    }

    public function test_create_task_rejects_invalid_status(): void
    {
        $this->postJson('/api/tasks', ['title' => 'T', 'status' => 'invalid'])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['status']);
    }

    // ── UPDATE ───────────────────────────────────────────────────────────────

    public function test_can_update_task_status_to_completed(): void
    {
        $task = $this->createTask();

        $this->patchJson("/api/tasks/{$task['id']}", ['status' => 'completed'])
            ->assertStatus(200)
            ->assertJsonFragment(['status' => 'completed']);
    }

    public function test_can_update_task_title(): void
    {
        $task = $this->createTask();

        $this->patchJson("/api/tasks/{$task['id']}", ['title' => 'Updated Title'])
            ->assertStatus(200)
            ->assertJsonFragment(['title' => 'Updated Title']);
    }

    public function test_update_nonexistent_task_returns_404(): void
    {
        $this->patchJson('/api/tasks/999', ['title' => 'Ghost'])
            ->assertStatus(404);
    }

    public function test_update_with_empty_title_fails_validation(): void
    {
        $task = $this->createTask();

        $this->patchJson("/api/tasks/{$task['id']}", ['title' => ''])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['title']);
    }

    // ── DESTROY ──────────────────────────────────────────────────────────────

    public function test_can_delete_task(): void
    {
        $task = $this->createTask();

        $this->deleteJson("/api/tasks/{$task['id']}")
            ->assertStatus(200)
            ->assertJsonFragment(['message' => 'Task deleted successfully.']);

        // Verify it no longer exists
        $this->getJson("/api/tasks/{$task['id']}")->assertStatus(404);
    }

    public function test_delete_nonexistent_task_returns_404(): void
    {
        $this->deleteJson('/api/tasks/999')
            ->assertStatus(404);
    }
}

