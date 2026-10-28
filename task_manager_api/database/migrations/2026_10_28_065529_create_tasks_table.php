<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * Creates the tasks table with all fields required by the assessment spec.
     */
    public function up(): void
    {
        Schema::create('tasks', function (Blueprint $table) {
            $table->id();                                                     // BIGINT UNSIGNED AUTO_INCREMENT PK
            $table->string('title', 255);                                    // required, max 255 chars
            $table->text('description')->nullable();                         // optional free-text description
            $table->enum('status', ['pending', 'completed'])
                  ->default('pending');                                       // default to pending
            $table->date('due_date')->nullable();                            // optional due date YYYY-MM-DD
            $table->timestamps();                                             // created_at, updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tasks');
    }
};
