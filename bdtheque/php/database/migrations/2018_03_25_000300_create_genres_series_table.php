<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateGenresSeriesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('genres_series', function (Blueprint $table) {
            $table->uuid('genre_id')->charset('ascii')->nullable(false);
            $table->uuid('serie_id')->charset('ascii')->nullable(false);

            $table->timestamps();
        });

        Schema::table('genres_series', function (Blueprint $table) {
            $table->primary(['genre_id', 'serie_id']);
            $table->index('genre_id');
            $table->index('serie_id');

            $table->foreign('genre_id')->references('id')->on('genres')->onUpdate('cascade')->onDelete('cascade');
            $table->foreign('serie_id')->references('id')->on('series')->onUpdate('cascade')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('genres_series');
    }
}
