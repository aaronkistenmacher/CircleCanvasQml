let selectedIndexes = [];
let lastSelectedColor = 'lightblue';

// QML doesn't know about JS array updates.
// Synchorize GUI with selectedIndexes here.
function synchronizeSelections() {
    for (let i = 0; i < circleModel.count; i++) {
        if (selectedIndexes.includes(i)) {
            circleModel.setProperty(i, 'selected', true);
        }
        else {
            circleModel.setProperty(i, 'selected', false);
        }
        circleModel.setProperty(i, 'mostRecentlySelected', false);
    }

    if (selectedIndexes.length > 0) {
        const mostRecent = selectedIndexes[selectedIndexes.length - 1];
        circleModel.setProperty(mostRecent, 'mostRecentlySelected', true);
    }

    if (selectedIndexes.length === 1 && circleModel.count > 1) {
        instructions.opacity = 1;
    }

    if (selectedIndexes.length === 0 && colorDialog.visible) {
        colorDialog.close();
    }
}

function clearSelections() {
    selectedIndexes = [];
    synchronizeSelections();
}

// Toggle selection for the circle at index.
function toggleSelection(index) {
    const i = selectedIndexes.findIndex((selection) => { return index === selection });
    if ( i === -1) {
        selectedIndexes.push(index);
    } else {
        selectedIndexes.splice(i, 1);
    }
    synchronizeSelections();
}

function handleCircleClicked(index, modifiers) {
    if (modifiers & Qt.ShiftModifier) {
        // Add or remove from current selection list
        toggleSelection(index);
    }
    else {
        const isSelected = selectedIndexes.includes(index);
        // Clear all selections
        clearSelections();
        // If circle was not selected, select it.
        if (!isSelected) {
            toggleSelection(index);
        }
    }
}

function deleteSelected() {
    for (let i = circleModel.count - 1; i >= 0; i--) {
        if (selectedIndexes.includes(i)) {
            circleModel.remove(i, 1);
        }
    }

    clearSelections();
}

function updateColorsForSelected(color) {
    selectedIndexes.forEach((index) => {
       circleModel.setProperty(index, 'color', '' + color); // convert color to string
    });

    lastSelectedColor = '' + color;
}

function updateRadiusForSelected(radius) {
    selectedIndexes.forEach((index) => {
       circleModel.setProperty(index, 'radius', radius);
    });
}

function updatePositionsForSelected(deltaX, deltaY) {
    selectedIndexes.forEach((index) => {
       const item = circleModel.get(index);
       item.centerX = item.centerX + deltaX;
       item.centerY = item.centerY + deltaY;
    });
}

