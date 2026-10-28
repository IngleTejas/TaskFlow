<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateTaskRequest extends FormRequest
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
     * Validation rules for updating a task.
     * 'sometimes' means the rule only applies when the key is present in the request,
     * which allows PATCH partial updates without requiring all fields.
     */
    public function rules(): array
    {
        return [
            'title'       => ['sometimes', 'required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'status'      => ['nullable', 'in:pending,completed'],
            'due_date'    => ['nullable', 'date_format:Y-m-d'],
        ];
    }
}

