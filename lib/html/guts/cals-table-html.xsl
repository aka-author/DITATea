<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:import href="../../../xatool/html/xsl-2.0/html.xsl"/>

    <xsl:import href="../../queries/queries.xsl"/>


    <!-- 
        Entry
    -->

    <!-- Style -->

    <xsl:template match="*[dtea:isCALSTableEntry(.)]" mode="dtea:css.styleItems" as="xs:string*">

        <xsl:value-of select="xat:css.styleItem('text-align', dtea:textAlign(.))"/>
        <xsl:value-of select="xat:css.styleItem('vertical-align', dtea:verticalAlign(.))"/>

        <xsl:if test="@width">
            <xsl:value-of select="xat:css.styleItem('width', dtea:width(.))"/>
        </xsl:if>
        
        <xsl:value-of select="xat:css.styleItem('height', dtea:height(.))"/>

    </xsl:template>

    <!-- Specific entry attributes -->

    <xsl:template match="*[dtea:isCALSTableEntry(.)]" mode="dtea:html.rowspanAttr">

        <xsl:variable name="rowspan" select="dtea:rowspan(.)" as="xs:integer"/>

        <xsl:if test="$rowspan &gt; 1">
            <xsl:attribute name="rowspan" select="$rowspan"/>
        </xsl:if>

    </xsl:template>

    <xsl:template match="*[dtea:isCALSTableEntry(.)]" mode="dtea:html.colspanAttr">

        <xsl:variable name="colspan" select="dtea:colspan(.)" as="xs:integer"/>

        <xsl:if test="$colspan &gt; 1">
            <xsl:attribute name="colspan" select="$colspan"/>
        </xsl:if>

    </xsl:template>

    <xsl:template match="*[dtea:isCALSTableEntry(.)]" mode="dtea:specificAttrs">

        <xsl:apply-templates select="." mode="dtea:html.rowspanAttr"/>
        <xsl:apply-templates select="." mode="dtea:html.colspanAttr"/>

    </xsl:template>


    <!-- 
        Row
    -->

    <xsl:template match="*[dtea:isCALSTableRow(.)]" mode="dtea:css.styleItems" as="xs:string*">
        <xsl:value-of select="xat:css.styleItem('vertical-align', dtea:verticalAlign(.))"/>
    </xsl:template>


    <!-- 
        Table title (caption)
    -->

    <xsl:template match="*" mode="dtea:html.tableCaption"/>

    <xsl:template match="*[dtea:isCALSTable(.)]/*[dtea:isTitle(.)]">
        <p>
            <xsl:apply-templates select="." mode="dtea:outAttrs"/>
            <xsl:apply-templates select="." mode="dtea:title.content"/>
        </p>
    </xsl:template>

    <xsl:template match="*[dtea:isTitle(.)]" mode="dtea:html.tableCaption">
        <caption>
            <div>
                <xsl:apply-templates select="." mode="dtea:outAttrs"/>
                <xsl:apply-templates select="." mode="dtea:title.content"/>
            </div>
            <xsl:apply-templates select="../*[contains(@class, ' topic/desc ')]"/>
        </caption>
    </xsl:template>


    <!-- 
        Colgroup and cols based on colspecs
    -->

    <!-- colspec to col -->

    <xsl:template match="*[dtea:isColspec(.)]" mode="dtea:outElementName">
        <xsl:value-of select="'col'"/>
    </xsl:template>

    <xsl:template match="*[dtea:isColspec(.)]" mode="dtea:css.styleItems" as="xs:string*">
        <xsl:value-of select="xat:css.styleItem('width', dtea:width(.))"/>
    </xsl:template>

    <!-- A sequence of tagroup/colspec to colgroup -->

    <xsl:template match="*" mode="dtea:html.colgroup"/>

    <xsl:template match="*[dtea:isTable(.) and *[dtea:isColspec(.)]]" mode="dtea:html.colgroup">

        <colgroup span="{dtea:countCols(.)}">
            <xsl:apply-templates select="*[dtea:isColspec(.)]"/>
        </colgroup>

    </xsl:template>


    <!-- 
        CALS tables     
    -->

    <xsl:template match="*[dtea:isCALSTable(.)]" mode="dtea:css.styleItems" as="xs:string*">

        <xsl:if test="../@pgwide = '1'">
            <xsl:value-of select="xat:css.styleItem('width', '100%')"/>
        </xsl:if>

    </xsl:template>


    <xsl:template match="*[dtea:isCALSTable(.)]">

        <table>

            <xsl:apply-templates select=".." mode="dtea:outAttrs"/>

            <xsl:apply-templates select="." mode="dtea:html.colgroup"/>

            <xsl:apply-templates select="." mode="dtea:html.tableContent"/>

        </table>

    </xsl:template>


    <!-- 
        Table containers
    -->

    <!-- Mono-table -->

    <xsl:template match="*[count(*[dtea:isCALSTable(.)]) = 1]">

        <xsl:variable name="table">
            <xsl:apply-templates select="*[dtea:isCALSTable(.)]"/>
        </xsl:variable>

        <table>

            <xsl:apply-templates select="." mode="dtea:outAttrs"/>

            <xsl:apply-templates select="*[dtea:isTitle(.)]" mode="dtea:html.tableCaption"/>

            <xsl:copy-of select="$table/table/*"/>

        </table>

    </xsl:template>

    <!-- Multi-table -->

    <xsl:template match="*[count(*[dtea:isCALSTable(.)]) &gt; 1]">

        <div>

            <xsl:apply-templates select="." mode="dtea:outAttrs"/>

            <xsl:apply-templates select="*[dtea:isTitle(.)]"/>
            
            <xsl:apply-templates select="*[contains(@class, ' topics/desc ')]"/>

            <xsl:apply-templates select="*[dtea:isCALSTable(.)]"/>

        </div>

    </xsl:template>

</xsl:stylesheet>
