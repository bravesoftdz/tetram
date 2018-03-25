<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateImagesAlbumsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('images_albums', function (Blueprint $table) {
            $table->uuid('id')->charset('ascii')->nullable(false)->primary();

            $table->unsignedSmallInteger('ordre')->nullable(false);
            $table->unsignedSmallInteger('categorie')->nullable(false);
            $table->string('fichier', 255)->nullable(false);
            $table->string('chemin', 255)->nullable(false);

            $table->uuid('album_id')->charset('ascii')->nullable(false);
            $table->uuid('edition_id')->charset('ascii')->nullable(true);

            $table->timestamps();
            $table->softDeletes();
        });

        Schema::table('images_albums', function (Blueprint $table) {
            $table->index('album_id');
            $table->index('edition_id');

            $table->foreign('album_id')->references('id')->on('albums')->onUpdate('cascade')->onDelete('cascade');
            $table->foreign('edition_id')->references('id')->on('editions')->onUpdate('cascade')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('image_albums');
    }
}
