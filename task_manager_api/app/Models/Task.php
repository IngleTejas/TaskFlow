<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     * Explicit list — do not use $guarded = [].
     */
    protected $fillable = [
        'title',
        'description',
        'status',
        'due_date',
    ];

    /**
     * Attribute casting.
     * due_date is cast to a plain date string "YYYY-MM-DD" for consistent JSON output.
     */
    protected $casts = [
        'due_date' => 'date:Y-m-d',
    ];
}

