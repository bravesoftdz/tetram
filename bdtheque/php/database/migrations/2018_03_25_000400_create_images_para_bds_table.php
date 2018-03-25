<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateImagesParaBdsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('images_para_bds', function (Blueprint $table) {
            $table->uuid('id')->charset('ascii')->nullable(false)->primary();

            $table->unsignedSmallInteger('ordre')->nullable(false);
            $table->unsignedSmallInteger('categorie')->nullable(false);
            $table->string('fichier', 255)->nullable(false);
            $table->string('chemin', 255)->nullable(false);

            $table->uuid('para_bd_id')->charset('ascii')->nullable(false);

            $table->timestamps();
            $table->softDeletes();
        });

        Schema::table('images_para_bds', function (Blueprint $table) {
            $table->index('para_bd_id');

            $table->foreign('para_bd_id')->references('id')->on('para_bds')->onUpdate('cascade')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('images_para_bds');
    }
}
