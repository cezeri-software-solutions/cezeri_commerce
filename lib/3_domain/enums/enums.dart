enum WeightUnit { mg, g, kg, t, stuek, ml, L }

enum Gender { empty, male, female }

enum Responsiveness { isMobil, isTablet }

enum AddOrSubtract { add, subtract }

enum PackingStationFilter { paid, picked, all }

//* Bei Teillieferungen, ob eine Teillierung von einem Auftrag generiert werden soll
//* oder eine Restlieferung aus einer Teillieferung generiert werden soll
enum GenType { partialToCreate, partialRest }

enum PicklistStatus { open, partiallyCompleted, completed }

enum PositionTo { up, down }

enum ChartType { incomingOrder, salesVolume }

//* Auftragsstaus im Marktplatz nach Importieren und Verschicken der Aufträge
enum OrderStatusUpdateType { onImport, onShipping, onCancel, onDelete }

enum GetReordersType { open, partialOpen, openOrPartialOpen, completed, all }

//* Ob der Bestand der Artikel absolut oder inkrementell geupdatet werden soll
enum ProductQuantityEditType { absolut, incremental }

//* Welches Dashboard es ist
enum DashboardType { salesVolumePerBrand, groupedSalesVolume, salesVolumeBetweenDates }

//* Um einen Zeitraum auswählen zu können
enum DateRangeType { today, yesterday, thisWeek, last7Days, last30Days, last90Days, thisMonth, lastMonth, thisYear, lastYear }
