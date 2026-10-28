<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreTaskRequest extends FormRequest
{
    /**
     * Determine if the user is authorised to make this request.
     * No authentication required for this assessment.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Validation rules for creating a task.
     */
    public function rules(): array
    {
        return [
            'title'       => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'status'      => ['nullable', 'in:pending,completed'],
            'due_date'    => ['nullable', 'date_format:Y-m-d'],
        ];
    }
}

