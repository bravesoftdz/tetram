<template>
    <div class="card-body">
        <div class="form-group row">
            <label for="genre" class="col-md-4 col-form-label text-md-right">{{ $t('Genre') }}</label>
            <div class="col-md-6">
                <input-text id="genre" :value="genre.genre"></input-text>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        name: "GenreForm",
        props: {
            genre: {
                type: [Object, Array],
                required: true
            }
        }
    }
</script>

<style scoped>

</style>