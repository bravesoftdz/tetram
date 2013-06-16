package org.tetram.bdtheque.data.bean;

import org.jetbrains.annotations.Nullable;

import java.util.UUID;

public interface TreeNodeBean {
    UUID getId();

    String getTreeNodeText();

    @Nullable
    Float getTreeNodeRating();
}
