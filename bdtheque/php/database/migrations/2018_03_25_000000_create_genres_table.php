<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateGenresTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('genres', function (Blueprint $table) {
            $table->uuid('id')->charset('ascii')->nullable(false)->primary();

            $table->string('genre', 30)->nullable(false);
            $table->char('initiale_genre', 1)->charset('ascii')->nullable(false);

            $table->timestamps();
            $table->softDeletes();
        });

        Schema::table('genres', function (Blueprint $table) {
            $table->unique('genre');
            $table->index('initiale_genre');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('genres');
    }
}
