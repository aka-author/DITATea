<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dtea="http://itsurim.com/dtea"
    xmlns:xat="http://itsurim.com/xatool" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:import href="../../../xatool/json/xsl-2.0/json.xsl"/>


    <xsl:template match="subjectdef" mode="dtea:json.taxonomyData">

        <data>

            <xsl:if test="@navtitle != ''">
                <xsl:attribute name="name" select="@navtitle"/>
            </xsl:if>

            <xsl:if test="@keys != ''">
                <xsl:attribute name="value" select="@keys"/>
            </xsl:if>

            <xsl:apply-templates select="subjectdef" mode="dtea:json.taxonomyData"/>

        </data>

    </xsl:template>


    <xsl:template match="subjectScheme" mode="dtea:json.taxonomyData">

        <data datatype="taxonomy">
            <xsl:apply-templates select="subjectdef" mode="dtea:json.taxonomyData"/>
        </data>

    </xsl:template>


    <xsl:template match="data" mode="dtea:json.taxonomy">

        <xsl:variable name="txName" select="xat:json.prop('name', xat:json.atomicValue(@name))"/>

        <xsl:variable name="txValue" select="xat:json.prop('value', xat:json.atomicValue(@value))"/>

        <xsl:variable name="taxon">

            <xsl:value-of select="$txName"/>

            <xsl:if test="@value">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="$txValue"/>
            </xsl:if>

            <xsl:if test="data">

                <xsl:variable name="txItems" as="xs:string*">
                    <xsl:apply-templates select="data" mode="dtea:json.taxonomy"/>
                </xsl:variable>

                <xsl:variable name="txArray">
                    <xsl:value-of select="concat('[', string-join($txItems, ', '), ']')"/>
                </xsl:variable>

                <xsl:variable name="taxa" select="xat:json.prop('taxa', $txArray)"/>

                <xsl:text>, </xsl:text>

                <xsl:value-of select="$taxa"/>

            </xsl:if>

        </xsl:variable>

        <xsl:value-of select="xat:codegen.braces($taxon)"/>

    </xsl:template>


    <xsl:template match="subjectScheme" mode="dtea:json.taxonomy">

        <xsl:variable name="taxonomyData">
            <xsl:apply-templates select="." mode="dtea:json.taxonomyData"/>
        </xsl:variable>
        
        <xsl:apply-templates select="$taxonomyData/data" mode="dtea:json.taxonomy"/>

    </xsl:template>

</xsl:stylesheet>