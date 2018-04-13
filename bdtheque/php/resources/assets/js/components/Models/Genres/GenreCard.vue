<template>
    <label>
        <span>{{ genre.genre }}</span>
        Genre
    </label>
</template>

<script>
    export default {
        name: "GenreCard",
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