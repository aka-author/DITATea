<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:import href="../../format/autoformat.xsl"/>


    <!-- 
        Common function
    -->

    <xsl:template match="*" mode="dtea:outElementName">
        <xsl:value-of select="'span'"/>
    </xsl:template>


    <!-- 
        Inlines
    -->

    <xsl:template match="*[dtea:isInline(.)]" mode="dtea:outElementName">
        <xsl:value-of select="'span'"/>
    </xsl:template>


    <!-- 
        Generic blocks
    -->

    <xsl:template match="*[dtea:isGenericBlock(.)]" mode="dtea:outElementName">
        <xsl:value-of select="'div'"/>
    </xsl:template>


    <!-- 
        Lists and items
    -->

    <xsl:template match="*[dtea:isListItem(.)]" mode="dtea:outElementName">
        <xsl:value-of select="'li'"/>
    </xsl:template>


    <xsl:template match="*[dtea:isList(.)]" mode="dtea:outElementName">
        <xsl:value-of select="'ul'"/>
    </xsl:template>


    <!-- 
        Tables
    -->

    <!-- Entries -->

    <xsl:template match="*[dtea:isTableHeadEntry(.)]" mode="dtea:outElementName">
        <xsl:value-of select="'th'"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTableBodyEntry(.)]" mode="dtea:outElementName">
        <xsl:value-of select="'td'"/>
    </xsl:template>

    <!-- Rows -->

    <xsl:template match="*[dtea:isTableRow(.)]" mode="dtea:outElementName">
        <xsl:value-of select="'tr'"/>
    </xsl:template>

    <!-- Table head -->

    <xsl:template match="*" mode="dtea:html.tableHead"/>


    <xsl:template match="*[*[dtea:isTableHeadRow(.)]]" mode="dtea:html.tableHead">

        <thead>
            <xsl:apply-templates select="*[dtea:isTableHeadRow(.)]"/>
        </thead>

    </xsl:template>


    <xsl:template match="*[*[dtea:isTableHead(.)]]" mode="dtea:html.tableHead">

        <thead>
            <xsl:apply-templates select="*[dtea:isTableHead(.)]" mode="dtea:outAttrs"/>
            <xsl:apply-templates select="*[dtea:isTableHead(.)]/*"/>
        </thead>

    </xsl:template>

    <!-- Table body -->

    <xsl:template match="*" mode="dtea:html.tableBody"/>


    <xsl:template match="*[*[dtea:isTableBodyRow(.)]]" mode="dtea:html.tableBody">

        <tbody>
            <xsl:apply-templates select="*[dtea:isTableBodyRow(.)]"/>
        </tbody>

    </xsl:template>


    <xsl:template match="*[*[dtea:isTableBody(.)]]" mode="dtea:html.tableBody">

        <tbody>
            <xsl:apply-templates select="*[dtea:isTableBody(.)]" mode="dtea:outAttrs"/>
            <xsl:apply-templates select="*[dtea:isTableBody(.)]/*"/>
        </tbody>

    </xsl:template>

    <!-- footers -->

    <xsl:template match="*" mode="dtea:html.tableFoot"/>

    <xsl:template match="*[*[dtea:isTableFoot(.)]]" mode="dtea:html.tableFoot">

        <tfoot>
            <xsl:apply-templates select="*[dtea:isTableFoot(.)]" mode="dtea:outAttrs"/>
            <xsl:apply-templates select="*[dtea:isTableFoot(.)]/*"/>
        </tfoot>

    </xsl:template>

    <!-- Entire table -->
    
    <xsl:template match="*[dtea:isTable(.)]" mode="dtea:html.tableContent">
        
        <xsl:apply-templates select="." mode="dtea:html.tableHead"/>
        <xsl:apply-templates select="." mode="dtea:html.tableBody"/>
        <xsl:apply-templates select="." mode="dtea:html.tableFoot"/>
        
    </xsl:template>

    <xsl:template match="*[dtea:isTable(.)]">

        <table>

            <xsl:apply-templates select="." mode="dtea:outAttrs"/>

            <xsl:apply-templates select="." mode="dtea:html.tableContent"/>

        </table>

    </xsl:template>

</xsl:stylesheet>
