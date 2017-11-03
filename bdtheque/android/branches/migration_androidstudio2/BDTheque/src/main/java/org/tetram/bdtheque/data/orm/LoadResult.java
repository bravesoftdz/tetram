package org.tetram.bdtheque.data.orm;

public enum LoadResult {
    /**
     * L'entité a été chargée
     */
    OK,
    /**
     * L'entité contient des annotations @Field mais le curseur ne contient pas d'enregistrement à charger
     */
    NOTFOUND,
    /**
     * l'entité n'utilise pas les annotations @Field
     */
    ERROR
}