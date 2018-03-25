<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUniversSeriesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('univers_series', function (Blueprint $table) {
            $table->uuid('univers_id')->charset('ascii')->nullable(false);
            $table->uuid('serie_id')->charset('ascii')->nullable(false);

            $table->timestamps();
        });

        Schema::table('univers_series', function (Blueprint $table) {
            $table->primary(['univers_id', 'serie_id']);
            $table->index('univers_id');
            $table->index('serie_id');

            $table->foreign('univers_id')->references('id')->on('univers')->onUpdate('cascade')->onDelete('cascade');
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
        Schema::dropIfExists('univers_series');
    }
}
