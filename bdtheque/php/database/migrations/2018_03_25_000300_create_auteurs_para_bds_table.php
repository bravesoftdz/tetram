<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAuteursParaBdsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('auteurs_para_bds', function (Blueprint $table) {
            $table->uuid('personne_id')->charset('ascii')->nullable(false);
            $table->uuid('para_bd_id')->charset('ascii')->nullable(false);
            $table->unsignedTinyInteger('metier')->nullable(false);

            $table->timestamps();
        });

        Schema::table('auteurs_para_bds', function (Blueprint $table) {
            $table->primary(['personne_id', 'para_bd_id', 'metier']);
            $table->index('personne_id');
            $table->index('para_bd_id');

            $table->foreign('personne_id')->references('id')->on('personnes')->onUpdate('cascade')->onDelete('cascade');
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
        Schema::dropIfExists('auteurs_para_bds');
    }
}
