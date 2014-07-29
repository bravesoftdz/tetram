/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * History.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.gui.utils;

import javafx.application.Platform;
import javafx.beans.property.*;
import javafx.collections.FXCollections;
import javafx.collections.ListChangeListener;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Node;
import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.gui.controllers.ApplicationMode;
import org.tetram.bdtheque.gui.controllers.MainController;
import org.tetram.bdtheque.gui.controllers.ModeGestionController;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.controllers.gestion.FicheEditController;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.utils.StringUtils;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.EnumSet;

/**
 * Created by Thierry on 18/07/2014.
 */
@Service
@Lazy
@Scope(ConfigurableBeanFactory.SCOPE_SINGLETON)

public class History {

    private final ReadOnlyListWrapper<HistoryItem> shown = new ReadOnlyListWrapper<>(this, "shown", FXCollections.observableArrayList());
    private final ReadOnlyListWrapper<HistoryItem> waiting = new ReadOnlyListWrapper<>(this, "waiting", FXCollections.observableArrayList());
    private final ReadOnlyListWrapper<HistoryItem> temporary = new ReadOnlyListWrapper<>(this, "waiting", FXCollections.observableArrayList());
    private final ReadOnlyIntegerWrapper current = new ReadOnlyIntegerWrapper(this, "current", -1);
    private final ReadOnlyObjectWrapper<WindowController> currentController = new ReadOnlyObjectWrapper<>(this, "currentController", null);

    private int lockCount = 0;
    private boolean processRegistered = false;

    @Autowired
    private MainController mainController;

    public History() {
        waiting.addListener((ListChangeListener<HistoryItem>) c -> {
            while (c.next())
                if (c.wasAdded())
                    registerProcessNext();
        });
    }

    private synchronized void registerProcessNext() {
        if (!processRegistered) {
            Platform.runLater(() -> {
                processRegistered = false;
                processNext();
            });
            processRegistered = true;
        }
    }

    public ObservableList<HistoryItem> getShown() {
        return shown.get();
    }

    public ReadOnlyListProperty<HistoryItem> shownProperty() {
        return shown.getReadOnlyProperty();
    }

    public ObservableList<HistoryItem> getWaiting() {
        return waiting.get();
    }

    public ReadOnlyListWrapper<HistoryItem> waitingProperty() {
        return waiting;
    }

    public int getCurrent() {
        return current.get();
    }

    public ReadOnlyIntegerProperty currentProperty() {
        return current.getReadOnlyProperty();
    }

    public void addConsultation(HistoryAction action) {
        addConsultation(new HistoryItem(action));
    }

    private void editConsultation(HistoryItem item) {
        shown.get(getCurrent()).update(item);
    }

    private void addItem(HistoryItem item) {
        current.set(getCurrent() + 1);
        if (getCurrent() == shown.size())
            shown.add((HistoryItem) item.clone());
        else {
            shown.subList(getCurrent(), shown.size()).clear();
            shown.set(getCurrent(), (HistoryItem) item.clone());
        }
    }

    public void addConsultation(HistoryItem item) {
        if (lockCount == 0) {
            final HistoryItem currentItem = getCurrent() == -1 ? null : shown.get(getCurrent());
            if (currentItem != null && item.action == currentItem.action) {
                if (HistoryAction.mustRefresh.contains(item.action))
                    editConsultation(item);
                else if (!HistoryAction.canRefresh.contains(item.action) || !currentItem.entity.equals(item.entity))
                    addItem(item);
            } else
                addItem(item);
        }
/*
        procedure Modifie;
        begin
            EditConsultation(Consult);
        end;

        procedure Ajoute;
        begin
            Inc(FCurrentConsultation);
            FListConsultation.Count := FCurrentConsultation + 1;
            if not Assigned(FListConsultation[FCurrentConsultation]) then
                FListConsultation[FCurrentConsultation] := TConsult.Create;
            Modifie;
        end;

            if not LongBool(FLockCount) then
            begin
                if (FCurrentConsultation > -1) and (Consult.Action = CurrentConsult.Action) then
                    with CurrentConsult do
                    begin
                        if Consult.Action in MustRefresh then
                            Modifie
                        else if not(Consult.Action in CanRefresh) or (Reference <> Consult.Reference) or (not IsEqualGUID(ReferenceGUID, Consult.ReferenceGUID)) or
                                (Reference2 <> Consult.Reference2) or (not IsEqualGUID(ReferenceGUID2, Consult.ReferenceGUID2)) then
                            Ajoute;
                    end
                else
                    Ajoute;
            end;
*/
    }

    public void addWaiting(HistoryAction action) {
        waiting.add(new HistoryItem(action));
    }

    public void addWaiting(HistoryAction action, AbstractDBEntity entity) {
        waiting.add(new HistoryItem(action, entity));
    }

    public void clear() {
        current.set(-1);
        first();
    }

    public void back() {
        if (getCurrent() > 0) {
            current.set(getCurrent() - 1);
            refresh();
        }
    }

    public void backWaiting() {
        addWaiting(HistoryAction.BACK);
    }

    public void first() {
        current.set(0);
        refresh();
    }

    public String getDescription(int position) {
        HistoryItem item = getShown().get(position);
        @NonNls String s = item.description;

        if (StringUtils.isNullOrEmpty(s)) {
            s = (position == getCurrent() ? "Ask: " : "Unknown: ") + DateTimeFormatter.ISO_LOCAL_DATE_TIME.format(LocalDate.now());
            item.description = s;
        }

        return s;
    }

    public boolean hasWaiting() {
        return !getWaiting().isEmpty();
    }

    public void go(int position) {
        if (position < 0 || position >= getShown().size()) return;
        current.set(position);
        refresh();
    }

    public void last() {
        current.set(getShown().size() - 1);
        refresh();
    }

    public void next() {
        if (!getShown().isEmpty() && getCurrent() < getShown().size() - 1) {
            current.set(getCurrent() + 1);
            refresh();
        }
    }

    private void lock() {
        lockCount++;
    }

    public void processNext() {
        if (!hasWaiting()) return;

        HistoryItem item = getWaiting().remove(0);
        open(item, false);
    }

    public void refresh() {
        addWaiting(HistoryAction.REFRESH);
    }

    public void setDescription(String description) {
        getShown().get(getCurrent()).description = description;
    }

    private void unlock() {
        if (lockCount > 0) lockCount--;
    }

    private synchronized boolean open(final HistoryItem item, boolean withLock) {
/*
    TfrmConsole.AddEvent(UnitName, 'THistory.Open ' + GetEnumName(TypeInfo(TActionConsultation), Integer(Consult.Action)));

    doCallback := False;
*/
        boolean result = true;

        if (withLock) lock();
        WindowController newController = null;
        try {
            if (HistoryAction.noSaveHistorique.contains(item.action)) {
                item.previousContainer = Forms.getLastContainer();
                item.previousView = Forms.getLastView();
                if (HistoryAction.usedInGestion.contains(item.action))
                    temporary.add(item);
            } else
                addConsultation(item);
            if (HistoryAction.modes.contains(item.action))
                temporary.clear();

            ModeGestionController gestionController;
            FicheEditController<?> editController;

            final EventHandler<ActionEvent> closeWindowHandler = event -> {
                temporary.remove(item);
                if (temporary.isEmpty() && mainController.getMode() == ApplicationMode.CONSULTATION)
                    refresh();
                    // SpringContext.CONTEXT.getBean(ModeConsultationController.class).refreshConsultationForm();
                else
                    Forms.setViewToContainer(item.previousView, item.previousContainer);
            };

            switch (item.action) {
                case MODE_CONSULTATION:
                    newController = Forms.showMode(ApplicationMode.CONSULTATION);
                    break;
                case MODE_GESTION:
                    newController = Forms.showMode(ApplicationMode.GESTION);
                    break;
                case BACK:
                    back();
                    break;
                case REFRESH:
                    result = open(shown.get(getCurrent()), true);
                    break;
                case FICHE:
                    newController = Forms.showFiche(item.entity);
                    break;
/*
                fcRecherche:
                    MAJRecherche(Consult.ReferenceGUID, Consult.Reference2, Consult.Stream);
                fcPreview:
                    frmFond.SetModalChildForm(TForm(Consult.Reference));
                fcGallerie:
                    Result := MAJGallerie(Consult.Reference2, Consult.ReferenceGUID);
                fcSeriesIncompletes:
                    MAJSeriesIncompletes;
                fcPrevisionsSorties:
                    MAJPrevisionsSorties;
                fcRecreateToolBar:
                    frmFond.RechargeToolBar;
                fcPrevisionsAchats:
                    MAJPrevisionsAchats;
                fcRefreshRepertoire:
                    frmFond.actActualiseRepertoire.Execute;
                fcRefreshRepertoireData:
                    frmFond.actActualiseRepertoireData;
                fcScripts:
                    doCallback := MAJRunScript(TAlbumFull(Consult.GestionVTV));
                fcConflitImport:
                    frmFond.SetModalChildForm(TForm(Consult.Reference));
*/
                case GESTION_AJOUT:
                    gestionController = SpringContext.CONTEXT.getBean(ModeGestionController.class);
                    editController = gestionController.showEditForm(item.entity);
                    newController = editController;

                    editController.setLabel(item.string);

                    editController.registerCancelHandler(closeWindowHandler, FicheEditController.HandlerPriority.LOW);
                    editController.registerOkHandler(closeWindowHandler, FicheEditController.HandlerPriority.LOW);

/*                    if not IsEqualGUID(GUID_NULL, Consult.ReferenceGUID) then
                        doCallback := not IsEqualGUID(GUID_NULL, TActionGestionAddWithRef(Consult.GestionProc)(Consult.GestionVTV, Consult.ReferenceGUID, Consult.GestionValeur))
                    else
                        doCallback := not IsEqualGUID(GUID_NULL, TActionGestionAdd(Consult.GestionProc)(Consult.GestionVTV, Consult.GestionValeur));
*/
                case GESTION_MODIF:
                    gestionController = SpringContext.CONTEXT.getBean(ModeGestionController.class);
                    editController = gestionController.showEditForm(item.entity);
                    newController = editController;

                    editController.registerCancelHandler(closeWindowHandler, FicheEditController.HandlerPriority.LOW);
                    editController.registerOkHandler(closeWindowHandler, FicheEditController.HandlerPriority.LOW);
/*
                    if IsEqualGUID(Consult.ReferenceGUID, GUID_NULL) then
                        doCallback := TActionGestionModif(Consult.GestionProc)(Consult.GestionVTV)
                    else
                        doCallback := TActionGestionModif2(Consult.GestionProc)(Consult.ReferenceGUID);
*/
                    break;
/*
                fcGestionSupp:
                    doCallback := TActionGestionSupp(Consult.GestionProc)(Consult.GestionVTV);
                fcGestionAchat:
                    doCallback := TActionGestionAchat(Consult.GestionProc)(Consult.GestionVTV);
                fcConsole:
                    TfrmConsole.Create(Application).Show;
*/
            }
/*
            if doCallback then
            begin
                if Assigned(Consult.GestionCallback) then
                    Consult.GestionCallback(Consult.GestionCallbackData);
                AddWaiting(fcRefreshRepertoire);
            end;
*/
            if (!result) {
                shown.remove(getCurrent());
                backWaiting();
                result = true;
            }
        } finally {
            if (withLock)
                unlock();
            if (newController != null)
                currentController.set(newController);
        }
/*
    if Assigned(FOnChange) and not(Consult.Action in NoSaveHistorique) then
       FOnChange(Self, Consult);
*/
        registerProcessNext();
        return result;
    }

    public enum HistoryAction {
        BACK, REFRESH, FICHE, RECHERCHE, PREVIEW, SERIES_INCOMPLETES,
        PREVISIONS_SORTIES, RECREATE_TOOL_BAR, PREVISIONS_ACHATS, REFRESH_REPERTOIRE, REFRESH_REPERTOIRE_DATA, SERIE, GESTION_AJOUT,
        GESTION_MODIF, GESTION_SUPP, GESTION_ACHAT, CONFLIT_IMPORT, GALERIE, MODE_CONSULTATION, MODE_GESTION, UNIVERS,
        CONSOLE, SCRIPTS;

        static final EnumSet<HistoryAction> mustRefresh = EnumSet.of(RECHERCHE);
        static final EnumSet<HistoryAction> canRefresh = EnumSet.of(FICHE, SERIES_INCOMPLETES, PREVISIONS_SORTIES, PREVISIONS_ACHATS, GALERIE, UNIVERS);
        static final EnumSet<HistoryAction> usedInGestion = EnumSet.of(GESTION_AJOUT, GESTION_MODIF, GESTION_SUPP, GESTION_ACHAT, CONFLIT_IMPORT);
        static final EnumSet<HistoryAction> modes = EnumSet.of(MODE_CONSULTATION, MODE_GESTION);
        static final EnumSet<HistoryAction> specials = EnumSet.of(BACK, REFRESH, PREVIEW, RECREATE_TOOL_BAR, REFRESH_REPERTOIRE, REFRESH_REPERTOIRE_DATA, CONSOLE, SCRIPTS);
        // à cause des callback, les appels de gestion ne peuvent pas être sauvés dans l'historique
        // et puis je vois pas bien à quoi ça pourrait servir
        static final EnumSet<HistoryAction> noSaveHistorique = buildEnumSet(specials, usedInGestion, modes);

        @SafeVarargs
        static EnumSet<HistoryAction> buildEnumSet(EnumSet<HistoryAction>... set) {
            final EnumSet<HistoryAction> enumSet = EnumSet.noneOf(HistoryAction.class);
            for (EnumSet<HistoryAction> historyActions : set) enumSet.addAll(historyActions);
            return enumSet;
        }
    }

    private class HistoryItem implements Cloneable {

        public String string = null;
        private HistoryAction action = null;
        private AbstractDBEntity entity;
        private String description = null;
        private Object previousContainer = null;
        private Node previousView = null;

        HistoryItem(HistoryAction action) {
            this.action = action;
        }

        public HistoryItem(HistoryAction action, AbstractDBEntity entity) {
            this(action);
            this.entity = entity.lightRef();
        }

        @SuppressWarnings("CloneDoesntDeclareCloneNotSupportedException")
        @Override
        public Object clone() {
            try {
                return super.clone();
            } catch (CloneNotSupportedException e) {
                e.printStackTrace();
                return null;
            }
        }

        public void update(HistoryItem item) {
            this.action = item.action;
            this.entity = item.entity;
            this.description = item.description;
            this.previousContainer = item.previousContainer;
            this.previousView = item.previousView;
            this.string = item.string;
        }
    }
}
