<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUniversParaBdsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('univers_para_bds', function (Blueprint $table) {
            $table->uuid('univers_id')->charset('ascii')->nullable(false);
            $table->uuid('para_bd_id')->charset('ascii')->nullable(false);

            $table->timestamps();
        });

        Schema::table('univers_para_bds', function (Blueprint $table) {
            $table->primary(['univers_id', 'para_bd_id']);
            $table->index('univers_id');
            $table->index('para_bd_id');

            $table->foreign('univers_id')->references('id')->on('univers')->onUpdate('cascade')->onDelete('cascade');
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
        Schema::dropIfExists('univers_para_bds');
    }
}
