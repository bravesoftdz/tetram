<template>
    <input type="text" :v-model=value @change="updateInput" class="form-control" :id="id">
</template>

<script>
    export default {
        name: "InputText",
        model: {
            prop: 'modelValue',
            event: 'change'
        },
        props: {
            value: {
                type: String,
                required: true
            },
            modelValue: {
                default: ""
            },
            id: {
                type: String,
                required: true
            },
        },
        methods: {
            updateInput(event) {
                this.$emit('change', this.value);
            }
        }
    }
</script>

<style scoped>

</style>