/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * BindingsTrace.java
 * Last modified by Tetram, on 2014-07-30T12:36:16CEST
 */

package org.fxsct.util;

import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.property.BooleanProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;

import java.io.PrintStream;
import java.io.PrintWriter;

public class BindingsTrace {
    public static <T> void change(final String name,
                                  final ObservableValue<T> observableValue, final PrintStream out) {
        change(name, observableValue, new PrintWriter(out), out == System.err);
    }

    public static <T> void change(final String name,
                                  final ObservableValue<T> observableValue, final PrintWriter out, final boolean enableStackTrace) {
        observableValue.addListener(new ChangeListener<T>() {
            @Override
            public void changed(
                    final ObservableValue<? extends T> observableList,
                    final T oldValue, final T newValue) {
                out.println(name + " changed from '"
                        + oldValue + "' to '" + newValue + "':");
                if (enableStackTrace) {
                    for (final StackTraceElement element : Thread
                            .currentThread().getStackTrace()) {
                        out.println("    " + element);
                    }
                }
                out.flush();
            }
        });
    }

    public static <T> void invalidate(final String name,
                                      final ObservableValue<T> observableValue, final PrintStream out) {
        invalidate(name, observableValue, new PrintWriter(out), out == System.err);
    }

    public static <T> void invalidate(final String name,
                                      final ObservableValue<T> observableValue, final PrintWriter out, final boolean enableStackTrace) {
        observableValue.addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable observable) {
                out.println(name + " invalidated. New Value: " + observable);
                if (enableStackTrace)
                    for (final StackTraceElement element : Thread.currentThread()
                            .getStackTrace()) {
                        out.println("    " + element);
                    }
                out.flush();
            }
        });
    }

    public static void main(final String[] args) {
        final BooleanProperty property = new SimpleBooleanProperty();

        change("property", property, System.out);
        invalidate("inv property", property, System.err);

        property.setValue(true);
        property.setValue(true);
        property.setValue(false);
    }

}
