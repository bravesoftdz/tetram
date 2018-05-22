<template>
    <v-progress-linear
            :indeterminate="true"
            :color="color"
            height="4"
            v-if="show"
    >
    </v-progress-linear>
</template>

<script>
    export default {
        name: 'progress-bar',
        props: {
            show: {
                type: [Boolean, String],
                required: true
            },
            color: {
                type: String,
                default: 'accent'
            }
        }
    }
</script>
