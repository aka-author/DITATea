<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:import href="basic-queries.xsl"/>


    <!-- 
        Detecting tables and table parts by the types 
    -->

    <!-- Regular entries -->

    <xsl:template match="*" mode="dtea:isTableHeadEntry" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTableHeadRow(.)]/*" mode="dtea:isTableHeadEntry" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTableHead(.)]/*/*" mode="dtea:isTableHeadEntry" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isTableHeadEntry" as="xs:boolean">

        <xsl:param name="entry"/>

        <xsl:apply-templates select="$entry" mode="dtea:isTableHeadEntry"/>

    </xsl:function>


    <xsl:template match="*" mode="dtea:isTableBodyEntry" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTableBodyRow(.)]/*" mode="dtea:isTableBodyEntry" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTableFootRow(.)]/*" mode="dtea:isTableBodyEntry" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTableBody(.)]/*/*" mode="dtea:isTableBodyEntry" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isTableBodyEntry" as="xs:boolean">

        <xsl:param name="entry"/>

        <xsl:apply-templates select="$entry" mode="dtea:isTableBodyEntry"/>

    </xsl:function>

    <!-- CALS entries -->

    <xsl:template match="*" mode="dtea:isCALSTableEntry" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/entry ')]" mode="dtea:isCALSTableEntry"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isCALSTableEntry" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:isCALSTableEntry"/>

    </xsl:function>

    <!-- CALS rows -->

    <xsl:template match="*" mode="dtea:isCALSTableRow" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/row ')]" mode="dtea:isCALSTableRow"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isCALSTableRow" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:isCALSTableRow"/>

    </xsl:function>

    <!-- CALS tables -->

    <xsl:template match="*" mode="dtea:isCALSTable" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/tgroup ')]" mode="dtea:isCALSTable"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isCALSTable" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:isCALSTable"/>

    </xsl:function>


    <!-- 
        Counting table components
    -->

    <!-- Tne number of columns in a table -->

    <xsl:template match="*" mode="dtea:countCols" as="xs:integer">
        <xsl:variable name="cols" select="ancestor-or-self::*[dtea:isCALSTable(.)][1]/@cols"/>
        <xsl:sequence select="xs:integer($cols)"/>
    </xsl:template>

    <xsl:function name="dtea:countCols" as="xs:integer">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:countCols"/>

    </xsl:function>

    <!-- The number of entries in a row -->

    <xsl:function name="dtea:countEntries" as="xs:integer">

        <xsl:param name="row"/>

        <xsl:sequence select="count($row/*)"/>

    </xsl:function>


    <!-- 
        Working with colspecs
    -->

    <!-- Or. numbers -->

    <xsl:template match="*[dtea:isColspec(.)]" mode="dtea:ordNumber" as="xs:integer">
        <xsl:value-of select="number(@colnum)"/>
    </xsl:template>

    <!-- Detecting colspecs of specific types -->

    <!-- A colspec with a fixed width provided -->

    <xsl:function name="dtea:isAbsWidthColspec" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:variable name="cw" select="$element/@colwidth"/>

        <xsl:sequence select="dtea:isColspec($element) and $cw != '' and not(contains($cw, '*'))"/>

    </xsl:function>

    <!-- A colspec with a persentage width provided -->

    <xsl:function name="dtea:isRelWidthColspec" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:variable name="cw" select="$element/@colwidth"/>

        <xsl:sequence select="dtea:isColspec($element) and $cw != '' and contains($cw, '*')"/>

    </xsl:function>

    <!-- The column width with * recalculated to % (if provided) -->

    <xsl:template match="*[dtea:isAbsWidthColspec(.)]" mode="dtea:width">
        <xsl:value-of select="@colwidth"/>
    </xsl:template>

    <xsl:template match="*[dtea:isRelWidthColspec(.)]" mode="dtea:width">

        <xsl:if test="not(exists(../*[dtea:isAbsWidthColspec(.)]))">

            <xsl:variable name="weight" select="number(substring-before(@colwidth, '*'))"
                as="xs:double"/>

            <xsl:variable name="weights" as="xs:double*">
                <xsl:for-each select="../*[dtea:isRelWidthColspec(.)]">
                    <xsl:value-of select="number(substring-before(@colwidth, '*'))"/>
                </xsl:for-each>
            </xsl:variable>

            <xsl:variable name="weightsTotal" select="sum($weights)" as="xs:double"/>

            <xsl:if test="$weightsTotal &gt; 0">
                <xsl:value-of select="concat(round(100 * $weight div $weightsTotal), '%')"/>
            </xsl:if>

        </xsl:if>

    </xsl:template>

    <!-- Colspec align -->

    <xsl:template match="*[dtea:isColspec(.)]" mode="dtea:textAlign">
        <xsl:value-of select="@align"/>
    </xsl:template>

    <!-- Getting a colspec by a colname -->

    <xsl:function name="dtea:colspecByName">

        <xsl:param name="entry"/>
        <xsl:param name="colname"/>

        <xsl:copy-of
            select="$entry/ancestor::*[dtea:isCALSTable(.)][1]/*[dtea:isColspec(.) and @colname = $colname]"/>

    </xsl:function>

    <!-- Getting a colspecs for a given entry -->

    <xsl:template match="*[dtea:isCALSTableEntry(.) and @colname]" mode="dtea:colspec">

        <xsl:variable name="cn" select="@colname"/>

        <xsl:copy-of select="dtea:colspecByName(., @colname)"/>

    </xsl:template>

    <xsl:template match="*[dtea:isCALSTableEntry(.) and not(@colname)]" mode="dtea:colspec">

        <xsl:variable name="cnum" select="dtea:colNumber(.)"/>

        <xsl:copy-of select="ancestor::*[dtea:isCALSTable(.)][1]/*[dtea:isColspec(.)][$cnum]"/>

    </xsl:template>

    <xsl:function name="dtea:colspec">

        <xsl:param name="entry"/>

        <xsl:apply-templates select="$entry" mode="dtea:colspec"/>

    </xsl:function>


    <!-- 
        Calculating rowspan and colspan for entries
    -->

    <!-- rowspan -->

    <xsl:template match="*" mode="dtea:rowspan" as="xs:integer">
        <xsl:value-of select="1"/>
    </xsl:template>

    <xsl:template match="*[@morerows]" mode="dtea:rowspan" as="xs:integer">
        <xsl:value-of select="number(@morerows) + 1"/>
    </xsl:template>

    <xsl:function name="dtea:rowspan" as="xs:integer">

        <xsl:param name="entry"/>

        <xsl:apply-templates select="$entry" mode="dtea:rowspan"/>

    </xsl:function>

    <!-- colspan -->

    <xsl:template match="*" mode="dtea:colspan" as="xs:integer">
        <xsl:value-of select="1"/>
    </xsl:template>

    <xsl:template match="*[not(@morecols) and @nameend]" mode="dtea:colspan" as="xs:integer">

        <xsl:variable name="colNumStart" select="dtea:ordNumber(dtea:colspecByName(., @namest))"
            as="xs:integer"/>

        <xsl:variable name="colNumEnd" select="dtea:ordNumber(dtea:colspecByName(., @nameend))"
            as="xs:integer"/>

        <xsl:value-of select="$colNumEnd - $colNumStart + 1"/>

    </xsl:template>

    <xsl:template match="*[@morecols]" mode="dtea:colspan" as="xs:integer">
        <xsl:value-of select="number(@morecols) + 1"/>
    </xsl:template>

    <xsl:function name="dtea:colspan" as="xs:integer">

        <xsl:param name="entry"/>

        <xsl:apply-templates select="$entry" mode="dtea:colspan"/>

    </xsl:function>


    <!-- 
        Detecting the position of an entry in the table 
    -->

    <!-- The row number of an entry -->

    <xsl:template match="*[contains(@class, ' topic/entry ')]" mode="dtea:rowNumber">
        <xsl:value-of select="count(../preceding-sibling::*) + 1"/>
    </xsl:template>

    <xsl:function name="dtea:rowNumber" as="xs:integer">

        <xsl:param name="entry"/>

        <xsl:apply-templates select="$entry" mode="dtea:rowNumber"/>

    </xsl:function>

    <!-- The column number of an entry -->

    <xsl:template match="*[contains(@class, ' topic/entry ')]" mode="dtea:colNumber" as="xs:integer">

        <xsl:variable name="colspans" as="xs:integer*">
            <xsl:for-each select="preceding-sibling::*[contains(@class, ' topic/entry ')]">
                <xsl:value-of select="dtea:colspan(.)"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="count($colspans) = 0">
                <xsl:value-of select="1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="sum($colspans) + 1"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:function name="dtea:colNumber">

        <xsl:param name="entry"/>

        <xsl:apply-templates select="$entry" mode="dtea:colNumber"/>

    </xsl:function>


    <!-- 
        Detecting properties of entries 
    -->

    <!-- Width -->

    <xsl:template match="*[dtea:isCALSTableEntry(.) and @width]" mode="dtea:width">
        <xsl:value-of select="@width"/>
    </xsl:template>

    <xsl:template match="*[dtea:isCALSTableEntry(.) and not(@width)]" mode="dtea:width">

        <xsl:variable name="colspec" select="dtea:colspec(.)"/>

        <xsl:if test="$colspec">
            <xsl:value-of select="dtea:width($colspec)"/>
        </xsl:if>

    </xsl:template>

    <!-- Align -->

    <xsl:template match="*[dtea:isCALSTableEntry(.) and @align]" mode="dtea:textAlign">
        <xsl:value-of select="@align"/>
    </xsl:template>

    <xsl:template match="*[dtea:isCALSTableEntry(.) and not(@align)]" mode="dtea:textAlign">

        <xsl:variable name="colspec" select="dtea:colspec(.)"/>

        <xsl:if test="$colspec">
            <xsl:value-of select="dtea:textAlign($colspec)"/>
        </xsl:if>

    </xsl:template>

    <!-- Valign -->

    <xsl:template match="*[dtea:isCALSTableRow(.) or dtea:isCALSTableEntry(.)]"
        mode="dtea:verticalAlign">
        <xsl:value-of select="@valign"/>
    </xsl:template>

</xsl:stylesheet>
