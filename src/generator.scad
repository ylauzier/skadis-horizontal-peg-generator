// The vertical distance between each board hole in millimeter.
VerticalDistanceBetweenPeg = 20;

// The horizontal distance between each board hole in millimeter.
HorizontalDistanceBetweenPeg = 40;

// The default amount of columns when using the generator.
DefaultColumns = 1;

// The default amount of rows when using the generator.
DefaultRows = 1;

// Imports the peg STL file.
module importPegFromStl() {
    import("./horizontal-peg.stl", convexity=3);
}

// Creates the peg and set it at the origin.
// TODO: It is hardcoded, but I think it could be nice to find a better solution.
module generateHorizonalPegAtOrigin() {
    // Set at 0, 0
    translate([-81.5, 0, 0]) {
        rotate([90, 0, 0]) {
            importPegFromStl();          
        } 
    } 
}

// Generates horizontal pegs.
module generateHorizonalPegs(
    columns = DefaultColumns, 
    rows = DefaultRows, 
    verticalDirection = 1, 
    horizontalDirection = 1, 
    decaleDirection = 1, 
    skipNColumns = 1, 
    skipNRows = 1,
    graph = false,
) {
    actualVerticalDistance = VerticalDistanceBetweenPeg * verticalDirection;
    actualHoritzontalDistance = HorizontalDistanceBetweenPeg * horizontalDirection;
    neverSkipColumns = skipNColumns == 1;
    neverSkipRows = skipNRows == 1;
    

    for (rowIndex = [0:rows - 1]) {
        graphRow = graph ? graph[rowIndex] : false;
        rowNumber = rowIndex + 1;
        middleRow = rowIndex % 2 != 0;
        distanceToAddAfterOrRemove = actualVerticalDistance * decaleDirection;

        if (neverSkipRows || rowNumber % skipNRows != 0) {
            translate([middleRow? distanceToAddAfterOrRemove : 0, 0, actualVerticalDistance * rowIndex]) {
                amountColumnsForRow = middleRow && !graphRow ? columns - 1 : columns;

                for (columnIndex = [0:amountColumnsForRow - 1]) {
                    columnNumber = columnIndex + 1;
                    graphRowLength = graphRow ? len(graphRow) : 0;
                    graphColumn = graphRow && graphRowLength > 0 ? graphRow[columnIndex] : graphRow ? false : true;

                    if ((neverSkipColumns || columnNumber % skipNColumns != 0) && graphColumn) {
                        translate([columnIndex * actualHoritzontalDistance, 0, 0]) {
                            generateHorizonalPegAtOrigin();
                        }
                    }
                }
            } 
        } 
    }
}

// Generates horizontal pegs from the top to the right of the origin.
module generateHorizontalPegsFromTopToRight(
    columns = DefaultColumns, 
    rows = DefaultRows, 
    skipNColumns = 1,
    skipNRows = 1,
    graph
) {
    generateHorizonalPegs(
        columns = columns, 
        rows = rows, 
        verticalDirection = -1, 
        horizontalDirection = 1, 
        decaleDirection = -1, 
        skipNColumns = skipNColumns, 
        skipNRows = skipNRows,
        graph = graph
    );
}

// Generates horizontal pegs from the top to the left of the origin.
module createHorizontalPegsFromTopToLeft(
    columns = DefaultColumns, 
    rows = DefaultRows, 
    skipNColumns = 1,
    skipNRows = 1
) {
    generateHorizonalPegs(
        columns = columns, 
        rows = rows, 
        verticalDirection = -1, 
        horizontalDirection = -1, 
        decaleDirection = 1, 
        skipNColumns = skipNColumns, 
        skipNRows = skipNRows
    );
}

// Generates horizontal pegs from the bottom to the right of the origin.
module createHorizontalPegsFromBottomToRight(
    columns = DefaultColumns, 
    rows = DefaultRows, 
    skipNColumns = 1,
    skipNRows = 1
) {
    generateHorizonalPegs(
        columns = columns, 
        rows = rows, 
        verticalDirection = 1, 
        horizontalDirection = 1, 
        decaleDirection = 1, 
        skipNColumns = skipNColumns, 
        skipNRows = skipNRows
    );
}

// Generates horizontal pegs from the bottom to the left of the origin.
module generateHorizontalPegsFromBottomToLeft(
    columns = DefaultColumns, 
    rows = DefaultRows, 
    skipNColumns = 1,
    skipNRows = 1
) {
    generateHorizonalPegs(
        columns = columns, 
        rows = rows, 
        verticalDirection = 1, 
        horizontalDirection = -1, 
        decaleDirection = -1, 
        skipNColumns = skipNColumns, 
        skipNRows = skipNRows
    );
}

// Generates horizontal pegs from a graph composed of true and false.
// True means that we put a peg and false means that we skip it.
// Example : 
// [
//      [ true, false, true ],
//      [ false, true, false ],
//      [ true, false, true ]
// ]
module generateHorizontalPegsFromGraph(graph) {
    columns = max([for(i=graph)len(i)]);
    rows = len(graph);

    generateHorizontalPegsFromTopToRight(
        columns = columns, 
        rows = rows,
        graph = graph
    );
}