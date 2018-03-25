<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAlbumsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('albums', function (Blueprint $table) {
            $table->uuid('id')->charset('ascii')->nullable(false)->primary();

            $table->string('titre_album', 150)->nullable(false);
            $table->string('initiale_titre_album', 1)->charset('ascii')->nullable(false);
            $table->unsignedSmallInteger('mois_parution')->nullable(true);
            $table->unsignedTinyInteger('annee_parution')->nullable(true);
            $table->unsignedTinyInteger('tome')->nullable(true);
            $table->unsignedTinyInteger('tome_debut')->nullable(true);
            $table->unsignedTinyInteger('tome_fin')->nullable(true);
            $table->boolean('hors_serie')->nullable(false)->default(false);
            $table->boolean('integrale')->nullable(false)->default(false);
            $table->unsignedSmallInteger('notation')->nullable(true);
            $table->longText('sujet')->nullable(true);
            $table->longText('notes')->nullable(true);

            $table->boolean('prevision_achat')->nullable(false)->default(false);
            $table->boolean('valide')->nullable(false)->default(true);

            $table->uuid('serie_id')->charset('ascii')->nullable(true);

            $table->timestamps();
            $table->softDeletes();
        });

        Schema::table('albums', function (Blueprint $table) {
            $table->unique('titre_album');
            $table->index('initiale_titre_album');
            $table->index('annee_parution');
            $table->index(['annee_parution', 'hors_serie', 'integrale', 'prevision_achat']);
            $table->index(['tome', 'hors_serie', 'integrale', 'serie_id']);
            $table->index(['tome_debut', 'tome_fin', 'hors_serie', 'integrale', 'serie_id']);
            $table->index(['hors_serie', 'integrale', 'serie_id', 'prevision_achat']);
            $table->index('serie_id');

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
        Schema::dropIfExists('albums');
    }
}
