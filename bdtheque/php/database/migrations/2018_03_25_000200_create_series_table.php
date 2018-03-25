<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateSeriesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('series', function (Blueprint $table) {
            $table->uuid('id')->charset('ascii')->nullable(false)->primary();

            $table->string('titre_serie', 150)->nullable(false);
            $table->string('initiale_titre_serie', 1)->charset('ascii')->nullable(false);
            $table->boolean('terminee')->nullable(true)->default(false);
            $table->boolean('complete')->nullable(true)->default(false);
            $table->boolean('suivre_manquants')->nullable(true)->default(true);
            $table->boolean('suivre_sorties')->nullable(true)->default(true);
            $table->unsignedTinyInteger('nb_albums')->nullable(true);
            $table->longText('sujet')->nullable(true);
            $table->longText('notes')->nullable(true);
            $table->string('site_web', 255)->nullable(true);
            $table->boolean('vo')->nullable(true)->default(false);
            $table->boolean('couleur')->nullable(true)->default(false);
            $table->unsignedSmallInteger('etat')->nullable(true);
            $table->unsignedSmallInteger('reliure')->nullable(true);
            $table->unsignedSmallInteger('type_edition')->nullable(true);
            $table->unsignedSmallInteger('orientation')->nullable(true);
            $table->unsignedSmallInteger('format_edition')->nullable(true);
            $table->unsignedSmallInteger('sens_lecture')->nullable(true);
            $table->unsignedSmallInteger('notation')->nullable(true);

            $table->uuid('editeur_id')->charset('ascii')->nullable(false);
            $table->uuid('collection_id')->charset('ascii')->nullable(true);

            $table->timestamps();
            $table->softDeletes();
        });

        Schema::table('series', function (Blueprint $table) {
            $table->unique('titre_serie');
            $table->index('initiale_titre_serie');
            $table->index('terminee');
            $table->index('editeur_id');
            $table->index('collection_id');

            $table->foreign('editeur_id')->references('id')->on('editeurs')->onUpdate('cascade')->onDelete('cascade');
            $table->foreign('collection_id')->references('id')->on('collections')->onUpdate('cascade')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('series');
    }
}
