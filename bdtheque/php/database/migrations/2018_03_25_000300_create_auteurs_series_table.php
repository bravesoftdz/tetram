<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAuteursSeriesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('auteurs_series', function (Blueprint $table) {
            $table->uuid('personne_id')->charset('ascii')->nullable(false);
            $table->uuid('serie_id')->charset('ascii')->nullable(false);
            $table->unsignedTinyInteger('metier')->nullable(false);

            $table->timestamps();
        });

        Schema::table('auteurs_series', function (Blueprint $table) {
            $table->primary(['personne_id', 'serie_id', 'metier']);
            $table->index('personne_id');
            $table->index('serie_id');

            $table->foreign('personne_id')->references('id')->on('personnes')->onUpdate('cascade')->onDelete('cascade');
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
        Schema::dropIfExists('auteurs_series');
    }
}
