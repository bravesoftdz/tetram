package org.tetram.bdtheque.utils;

import org.tetram.bdtheque.gui.activities.fragments.FicheFragment;

import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Inherited
public @interface ShowFragmentClass {
    Class<? extends FicheFragment> value();
}
