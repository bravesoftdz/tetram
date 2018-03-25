<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUniversAlbumsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('univers_albums', function (Blueprint $table) {
            $table->uuid('univers_id')->charset('ascii')->nullable(false);
            $table->uuid('album_id')->charset('ascii')->nullable(false);

            $table->timestamps();
        });

        Schema::table('univers_albums', function (Blueprint $table) {
            $table->primary(['univers_id', 'album_id']);
            $table->foreign('univers_id')->references('id')->on('univers')->onUpdate('cascade')->onDelete('cascade');
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
        Schema::dropIfExists('univers_albums');
    }
}
