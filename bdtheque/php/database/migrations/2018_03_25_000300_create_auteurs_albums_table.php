<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAuteursAlbumsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('auteurs_albums', function (Blueprint $table) {
            $table->uuid('personne_id')->charset('ascii')->nullable(false);
            $table->uuid('album_id')->charset('ascii')->nullable(false);
            $table->unsignedTinyInteger('metier')->nullable(false);

            $table->timestamps();
        });

        Schema::table('auteurs_albums', function (Blueprint $table) {
            $table->primary(['personne_id', 'album_id', 'metier']);
            $table->index('personne_id');
            $table->index('album_id');

            $table->foreign('personne_id')->references('id')->on('personnes')->onUpdate('cascade')->onDelete('cascade');
            $table->foreign('album_id')->references('id')->on('albums')->onUpdate('cascade')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('auteurs_albums');
    }
}
