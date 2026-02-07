CREATE PROCEDURE [wrk].[Load_Date]
AS
    BEGIN
        SELECT
            CAST(CONVERT(VARCHAR, Date, 112) AS INT)                                                    AS DateKey,
            CONVERT(varchar, Date, 106)                                                                 AS Day,
            Cast([DATE] as Date)                                                                        AS Date,
            Cast(YEAR(Date) as int)                                                                     AS YearID,
            Cast(YEAR(Date) as nvarchar)                                                                AS Year,
            Cast([YEAR] as date)                                                                        AS YearDate,
            (Cast(YEAR(Date) as nvarchar) + ' ' + 'Q' + Cast(QUARTER_OF_YEAR as nvarchar))              AS Quarter,
            Cast(Cast([QUARTER] as Date) as nvarchar)                                                   AS QuarterDate,
            Cast(YEAR(Date) as nvarchar) + ' ' + FORMAT(Cast([MONTH_NAME] as Date), 'MMM')              AS Month,
            cast([MONTH] as date)                                                                       AS MonthDate,
            FORMAT([WEEK], 'MMM') + ' ' + FORMAT([WEEK], 'dd')                                          AS Week,
            Cast([WEEK] as date)                                                                        AS WeekDate,
            ('Day' + ' ' + Cast([DAY_OF_YEAR] as nvarchar))                                             AS DayOfYear,
            [DAY_OF_YEAR]                                                                               AS DayOfYearID,
            'Day' + ' ' + Cast([DAY_OF_MONTH] as nvarchar)                                              AS DayOfMonth,
            [DAY_OF_MONTH]                                                                              AS DayOfMonthID,
            FORMAT(cast([DATE] as Date), 'ddd')                                                         AS DayOfWeek,
            [DAY_OF_WEEK]                                                                               AS DayOfWeekID,
            ('Week' + ' ' + cast(WEEK_OF_YEAR as nvarchar))                                             AS WeekOfYear,
            [WEEK_OF_YEAR]                                                                              AS WeekOfYearID,
            'Month' + ' ' + cast([MONTH_OF_QUARTER] as nvarchar)                                        AS MonthOfQuarter,
            [MONTH_OF_QUARTER]                                                                          AS MonthOfQuarterID,
            format(Cast([Date] as date), 'MMM')                                                         AS MonthOfYear,
            cast([MONTH_OF_YEAR] as int)                                                                AS MonthOfYearID,
            ('Q' + cast([QUARTER_OF_YEAR] as nvarchar))                                                 AS QuarterOfYear,
            [QUARTER_OF_YEAR]                                                                           AS QuarterOfYearID,
            Cast(YEAR(Date) as int)                                                                     AS FiscalYearID,
            'FY' + ' ' + Cast(YEAR(Date) as nvarchar)                                                   AS FiscalYear,
            Cast([YEAR] as date)                                                                        AS FiscalYearDate,
            'FY' + ' ' + (Cast(YEAR(Date) as nvarchar) + ' ' + 'Q' + Cast(QUARTER_OF_YEAR as nvarchar)) AS FiscalQuarter,
            Cast(Cast([QUARTER] as Date) as nvarchar)                                                   AS FiscalQuarterDate,
            cast([MONTH] as date)                                                                       AS FiscalMonthDate,
            Format(cast([MONTH] as date), 'yyyy-MM')                                                    AS FiscalMonth,
            Cast([WEEK] as date)                                                                        AS FiscalWeekDate,
            FORMAT([WEEK], 'MMM') + ' ' + FORMAT([WEEK], 'dd')                                          AS FiscalWeek,
            [DAY_OF_YEAR]                                                                               AS FiscalDayOfYearID,
            ('Fiscal' + ' ' + 'day' + ' ' + Cast([DAY_OF_YEAR] as nvarchar))                            AS FiscalDayOfYear,
            [DAY_OF_MONTH]                                                                              AS FiscalDayOfMonthID,
            'Fiscal' + ' ' + 'day' + '' + Cast([DAY_OF_MONTH] as nvarchar)                              AS FiscalDayOfMonth,
            [WEEK_OF_YEAR]                                                                              AS FiscalWeekOfYearID,
            ('Fiscal' + ' ' + 'week' + ' ' + cast(WEEK_OF_YEAR as nvarchar))                            AS FiscalWeekOfYear,
            cast([MONTH_OF_YEAR] as int)                                                                AS FiscalMonthOfYearID,
            format(Cast([Date] as date), 'MMM')                                                         AS FiscalMonthOfYear,
            [MONTH_OF_QUARTER]                                                                          AS FiscalMonthOfQuarterID,
            'Fiscal' + ' ' + 'month' + ' ' + cast([MONTH_OF_QUARTER] as nvarchar)                       AS FiscalMonthOfQuarter,
            [QUARTER_OF_YEAR]                                                                           AS FiscalQuarterOfYearID,
            ('Fiscal' + ' ' + 'Q' + cast([QUARTER_OF_YEAR] as nvarchar))                                AS FiscalQuarterOfYear,
            CASE
                WHEN [DAY_OF_WEEK] in (
                                          1, 7
                                      )
                    THEN 'Weekend'
                ELSE
                    'Weekday'
            END                                                                                         AS WeekdayStatus,
            max(Cast([DATE] as Date)) over (Partition by
                                                cast([MONTH] as date)
                                           )                                                            AS MonthEndDate,
            max(Cast([DATE] as Date)) over (Partition by
                                                cast([MONTH] as date)
                                           )                                                            AS FiscalMonthEndDate
        INTO
            #DETAIL
        FROM
            [dbo].[BIDATEDIMENSIONVALUE]
        where
            Cast(cast(Date as nvarchar) as date) >= Cast(Cast(2012 / 01 / 01 as nvarchar) as date)
            and Cast(cast(Date as nvarchar) as date) <= DATEADD(Year, 1, GETDATE())
        ORDER By
            [DATE];

 /* Truncate */
        TRUNCATE TABLE dmo.Dim_Date

/* Insert / update dimension table  */
        INSERT INTO dmo.Dim_Date
            (
                DateKey,
                Day,
                Date,
                YearID,
                Year,
                YearDate,
                Quarter,
                QuarterDate,
                Month,
                MonthDate,
                Week,
                WeekDate,
                DayOfYear,
                DayOfYearID,
                DayOfMonth,
                DayOfMonthID,
                DayOfWeek,
                DayOfWeekID,
                WeekOfYear,
                WeekOfYearID,
                MonthOfQuarter,
                MonthOfQuarterID,
                MonthOfYear,
                MonthOfYearID,
                QuarterOfYear,
                QuarterOfYearID,
                FiscalYearID,
                FiscalYear,
                FiscalYearDate,
                FiscalQuarter,
                FiscalQuarterDate,
                FiscalMonthDate,
                FiscalMonth,
                FiscalWeekDate,
                FiscalWeek,
                FiscalDayOfYearID,
                FiscalDayOfYear,
                FiscalDayOfMonthID,
                FiscalDayOfMonth,
                FiscalWeekOfYearID,
                FiscalWeekOfYear,
                FiscalMonthOfYearID,
                FiscalMonthOfYear,
                FiscalMonthOfQuarterID,
                FiscalMonthOfQuarter,
                FiscalQuarterOfYearID,
                FiscalQuarterOfYear,
                WeekdayStatus,
                MonthEndDate,
                FiscalMonthEndDate
            )
                    SELECT
                        DateKey,
                        Day,
                        Date,
                        YearID,
                        Year,
                        YearDate,
                        Quarter,
                        QuarterDate,
                        Month,
                        MonthDate,
                        Week,
                        WeekDate,
                        DayOfYear,
                        DayOfYearID,
                        DayOfMonth,
                        DayOfMonthID,
                        DayOfWeek,
                        DayOfWeekID,
                        WeekOfYear,
                        WeekOfYearID,
                        MonthOfQuarter,
                        MonthOfQuarterID,
                        MonthOfYear,
                        MonthOfYearID,
                        QuarterOfYear,
                        QuarterOfYearID,
                        FiscalYearID,
                        FiscalYear,
                        FiscalYearDate,
                        FiscalQuarter,
                        FiscalQuarterDate,
                        FiscalMonthDate,
                        FiscalMonth,
                        FiscalWeekDate,
                        FiscalWeek,
                        FiscalDayOfYearID,
                        FiscalDayOfYear,
                        FiscalDayOfMonthID,
                        FiscalDayOfMonth,
                        FiscalWeekOfYearID,
                        FiscalWeekOfYear,
                        FiscalMonthOfYearID,
                        FiscalMonthOfYear,
                        FiscalMonthOfQuarterID,
                        FiscalMonthOfQuarter,
                        FiscalQuarterOfYearID,
                        FiscalQuarterOfYear,
                        WeekdayStatus,
                        MonthEndDate,
                        FiscalMonthEndDate
                    FROM
                        #Detail
    End
Go