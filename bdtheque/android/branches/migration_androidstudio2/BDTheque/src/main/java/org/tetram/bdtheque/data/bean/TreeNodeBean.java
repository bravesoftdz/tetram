package org.tetram.bdtheque.data.bean;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.enums.Notation;

import java.util.UUID;

public interface TreeNodeBean {
    UUID getId();

    String getTreeNodeText();

    @Nullable
    Notation getTreeNodeRating();
}
