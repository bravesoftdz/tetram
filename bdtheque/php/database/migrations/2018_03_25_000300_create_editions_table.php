<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateEditionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('editions', function (Blueprint $table) {
            $table->uuid('id')->charset('ascii')->nullable(false)->primary();

            $table->boolean('vo')->nullable(true)->default(false);
            $table->boolean('couleur')->nullable(true)->default(false);
            $table->unsignedSmallInteger('etat')->nullable(true);
            $table->unsignedSmallInteger('reliure')->nullable(true);
            $table->unsignedSmallInteger('type_edition')->nullable(true);
            $table->unsignedSmallInteger('orientation')->nullable(true);
            $table->unsignedSmallInteger('format_edition')->nullable(true);
            $table->unsignedSmallInteger('sens_lecture')->nullable(true);
            $table->date('date_achat')->nullable(true);
            $table->unsignedSmallInteger('annee_edition')->nullable(true);
            $table->decimal('prix', 15, 2)->nullable(true);
            $table->boolean('dedicace')->nullable(true)->default(false);
            $table->boolean('gratuit')->nullable(true)->default(false);
            $table->boolean('offert')->nullable(true)->default(false);
            $table->unsignedSmallInteger('nombre_de_pages')->nullable(true);
            $table->string('isbn', 13)->nullable(true);
            $table->string('numero_perso', 25)->nullable(true);
            $table->longText('notes')->nullable(true);

            $table->uuid('album_id')->charset('ascii')->nullable(false);
            $table->uuid('editeur_id')->charset('ascii')->nullable(false);
            $table->uuid('collection_id')->charset('ascii')->nullable(true);

            $table->timestamps();
            $table->softDeletes();
        });

        Schema::table('editions', function (Blueprint $table) {
            $table->index('album_id');
            $table->index('editeur_id');
            $table->index('collection_id');

            $table->foreign('album_id')->references('id')->on('albums')->onUpdate('cascade')->onDelete('cascade');
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
        Schema::dropIfExists('editions');
    }
}
