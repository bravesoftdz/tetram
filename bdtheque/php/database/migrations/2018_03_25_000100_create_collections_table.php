<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCollectionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('collections', function (Blueprint $table) {
            $table->uuid('id')->charset('ascii')->nullable(false)->primary();

            $table->string('nom_collection', 50)->nullable(false);
            $table->char('initiale_nom_collection', 1)->charset('ascii')->nullable(false);

            $table->uuid('editeur_id')->charset('ascii')->nullable(false);

            $table->timestamps();
            $table->softDeletes();
        });

        Schema::table('collections', function (Blueprint $table) {
            $table->index('editeur_id');
            $table->index('initiale_nom_collection');
            $table->unique(['editeur_id', 'nom_collection']);

            $table->foreign('editeur_id')->references('id')->on('editeurs')->onUpdate('cascade')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('collections');
    }
}
