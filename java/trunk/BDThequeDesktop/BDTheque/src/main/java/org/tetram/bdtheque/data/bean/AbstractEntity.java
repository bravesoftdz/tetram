package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ReadOnlyStringWrapper;
import javafx.beans.property.StringProperty;
import javafx.beans.value.ObservableValue;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.TestOnly;

import java.lang.reflect.*;
import java.util.Collection;

/**
 * Created by Thierry on 24/05/2014.
 */
public abstract class AbstractEntity {

    @NonNls
    private StringProperty label = new ReadOnlyStringWrapper(this, "label", null){
        @Override
        public String get() {
            super.get();
            return AbstractEntity.this.buildLabel();
        }
    };

    protected AbstractEntity() {
    }

    @Override
    public String toString() {
        return buildLabel();
    }

    public String buildLabel() {
        return "";
    }

    @SuppressWarnings({"HardCodedStringLiteral", "unchecked", "RedundantCast"})
    @TestOnly
    public final int fullCompare(AbstractEntity to) {
        assert this.getClass().isAssignableFrom(to.getClass());

        Class<?> rt;
        int compare = 0;
        for (Method method : getClass().getMethods()) {
            if (!method.getName().startsWith("get") && !method.getName().startsWith("is")) continue;
            if (method.getName().equals("getAssociations")) continue;
            if (Modifier.isNative(method.getModifiers())) continue; // on ne peut pas créer de méthodes natives
            if (!Modifier.isPublic(method.getModifiers())) continue; // toutes nos méthodes sont public

            rt = method.getReturnType();
            if (AbstractEntity.class.isAssignableFrom(rt)) {
                try {
                    AbstractEntity oThis = (AbstractEntity) method.invoke(this);
                    AbstractEntity oTo = (AbstractEntity) method.invoke(to);
                    compare = oThis.fullCompare(oTo);
                } catch (IllegalAccessException | InvocationTargetException e) {
                    e.printStackTrace();
                }
                if (compare != 0) return compare;
            } else if (Collection.class.isAssignableFrom(rt)) {
                ParameterizedType pType = (ParameterizedType) method.getGenericReturnType();
                Type type = pType.getActualTypeArguments()[0];

                try {
                    Collection<?> listThis = (Collection<?>) method.invoke(this);
                    Collection<?> listTo = (Collection<?>) method.invoke(to);

                    if (listThis == null && listTo != null)
                        return -1;
                    if (listThis != null && listTo == null)
                        return 1;
                    if (listThis != null) {
                        compare = listThis.size() - listTo.size();
                        if (compare != 0) return compare;

                        for (Object oThis : listThis) {
                            boolean found = false;
                            for (Object oTo : listTo) {
                                found = oThis.equals(oTo);
                                if (found) {
                                    if (type instanceof AbstractEntity) {
                                        compare = ((AbstractEntity) oThis).fullCompare((AbstractEntity) oTo);
                                    } else if (type instanceof Comparable) {
                                        compare = ((Comparable) oThis).compareTo(oTo);
                                    } else
                                        compare = 0;
                                    if (compare != 0) return compare;
                                    break;
                                }
                            }
                            if (!found) return -1;
                        }
                    }

                } catch (IllegalAccessException | InvocationTargetException e) {
                    e.printStackTrace();
                }
            } else {
                Object oThis;
                Object oTo;
                try {
                    oThis = method.invoke(this);
                    oTo = method.invoke(to);

                    if (oThis == null && oTo != null)
                        return -1;
                    if (oThis != null && oTo == null)
                        return 1;

                    if (oThis != null) {
                        if (Comparable.class.isAssignableFrom(rt)) {
                            compare = ((Comparable) oThis).compareTo(oTo);
                            if (compare != 0) return compare;
                        } else {
                            if (!oThis.equals(oTo))
                                return -1;
                        }
                    }
                } catch (IllegalAccessException | InvocationTargetException e) {
                    e.printStackTrace();
                }
            }
        }

        return 0;
    }

    public ObservableValue<String> labelProperty() {
        return label;
    }
}
